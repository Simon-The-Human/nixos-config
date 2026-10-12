# Шаблон клиента для NixOS: весь трафик системы через VLESS-сервер (роль xray)
# — Xray в режиме TUN вместо Happ. Проверен на ВМ NixOS 26.05 и у semen_comp
# (2026-09-30), подробности — README роли, раздел «UDP и игры».
#
# Ключа в этом файле нет, его можно класть в публичный git. Параметры ключа —
# в /etc/xray/proxy.json на самой машине (root, 600), образец —
# nixos-xray-proxy.example.json рядом; заполняется из ссылки клиента
# (xray-clients link ИМЯ). UUID из ссылки — это доступ к VPN: вписанный прямо
# в модуль, он уехал в публичный репозиторий (semen_comp, найдено 2026-10-12).
#
# Нужен Xray не старше 26.6.27 (в nixos-26.05 — 26.3.27, TUN там ломает UDP):
# во flake.nix отдельный вход и строка в оверлее —
#   inputs.nixpkgs-xray.url = "github:nixos/nixpkgs/nixos-unstable";
#   xray-new = (import inputs.nixpkgs-xray { inherit system; }).xray;
# Happ на этой машине выключить: два TUN мешают друг другу.
{
  config,
  lib,
  pkgs,
  ...
}:

# Xray вместо Happ: весь трафик системы через VLESS-сервер (Нидерланды).
#
# TUN, а не TPROXY: Xray сам заводит интерфейс xray0 и маршруты в него и сам
# привязывает свои соединения к физическому интерфейсу, чтобы не зациклиться.
# iptables не нужен. Happ при этом должен быть выключен — два TUN мешают друг
# другу.
let
  # Файл с ключом. systemd читает его от root и отдаёт службе копию
  # (LoadCredential) — в /nix/store он не попадает.
  proxyFile = "/home/simon/.config/xray/proxy.json";

  # Свои правила — правь здесь, потом nixos-rebuild switch. Проверяются
  # раньше общих, поэтому ими можно переопределить что угодно ниже.
  #   "domain:arenadata.io"    — домен со всеми поддоменами
  #   "full:chat.arenadata.io" — только это имя
  #   "domain:by"              — целая зона
  #   "keyword:sber"           — в имени есть слово
  # Без правки российское на чужих доменах (.com, .io …) идёт через VPN —
  # работает, но с крюком; российские .ru и известные сервисы уже напрямую.
  # Проверить, куда идёт сайт: узнать его адрес и посмотреть журнал Xray —
  #   getent ahostsv4 chat.arenadata.io | head -1
  #   journalctl -u xray -f        # открыть сайт; в строке с его адресом
  #                                # в конце [… direct] — мимо VPN, [… proxy] — через VPN
  myDirect = [
    "domain:arenadata.io"
    "domain:ru"
    "domain:su"
    "domain:рф"
    "domain:vk.com"
    "domain:yandex.com"
    "domain:yandex.net"
    "domain:shiruho.com"
    "domain:senkuro.me"
    "domain:adsw.io"
    "domain:arenadata.io"
    "domain:arenadata.tech"
    "domain:yandex"
    "domain:yandex.go"
    "domain:pitomniki.shop"
    "domain:filbert.pro"
    "domain:rick-i-morty.net"
    "domain:shedevrum.ai"
    "domain:yummyani.me"
    "domain:giga.chat"
    "domain:gazelkin.com"
  ]; # мимо VPN: российское на чужих доменах, рабочие сервисы
  myProxy = [ ]; # всегда через VPN, даже если российское
in
{
  services.xray = {
    enable = true;
    # TUN разводит UDP одного сокета по разным адресам только начиная с
    # Xray 26.6.27. В nixos-26.05 — 26.3.27: там весь UDP сокета уходит на
    # первый адрес (Warframe не видит серверов DE и игроков), и конфиг с TUN
    # даже не проходит проверку при сборке. Свежий Xray — из отдельного входа
    # флейка nixpkgs-xray (оверлей xray-new), остальной unstable не трогаем.
    package = pkgs.xray-new;

    settings = {
      log.loglevel = "warning";

      inbounds = [
        {
          tag = "tun-in";
          protocol = "tun";
          settings = {
            name = "xray0";
            mtu = 1500;
            # Всё, что не уходит более точными маршрутами (локалка, офисный
            # OpenVPN, docker, libvirt), — в туннель. IPv6 тоже, иначе утечёт.
            autoSystemRoutingTable = [
              "0.0.0.0/0"
              "::/0"
            ];
            autoOutboundsInterface = "auto";
          };
          # Адрес назначения — по имени сайта из TLS/HTTP: его резолвит VPN-
          # сервер, и подмена DNS у провайдера (Discord и прочее заблокированное)
          # не мешает. Без подмены Discord не работал.
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
            ];
            # Кроме Warframe: чат идёт на IP 172.232.25.131 с именем
            # irc.warframe.com, а оно не резолвится ни у кого (CNAME на пустую
            # запись Cloudflare) — с подменой чат не подключался.
            domainsExcluded = [ "domain:warframe.com" ];
          };
        }
        # SOCKS5 для программ, которым нужен явный прокси
        {
          tag = "socks-in";
          listen = "127.0.0.1";
          port = 20808;
          protocol = "socks";
          settings = {
            auth = "noauth";
            udp = true;
          };
        }
      ];

      outbounds = [
        # Заглушка. При запуске Xray читает ещё proxyFile, и outbound с тем же
        # тегом оттуда заменяет этот целиком, на том же месте — первым, то есть
        # маршрутом по умолчанию. Здесь она нужна, чтобы конфиг прошёл
        # проверку xray -test при сборке. Настоящий outbound — XHTTP + Reality
        # с xmux: все соединения внутри одного-двух TLS, иначе пачки
        # параллельных TLS к зарубежному IP ТСПУ «замораживает».
        {
          tag = "proxy";
          protocol = "vless";
          settings.vnext = [
            {
              address = "127.0.0.1";
              port = 443;
              users = [
                {
                  id = "00000000-0000-0000-0000-000000000000";
                  encryption = "none";
                }
              ];
            }
          ];
        }
        {
          tag = "direct";
          protocol = "freedom";
        }
        {
          tag = "block";
          protocol = "blackhole";
        }
      ];

      # Правила сверху вниз, первое совпавшее решает; всё, что не попало
      # ни в одно, — в первый outbound (proxy).
      #
      # Подмена адреса именем (sniffing выше) делает цель доменом, и правило
      # geoip:ru ниже ловит только соединения без имени (звонки по IP).
      # Российское на чужих доменах (chat.arenadata.io в VK Cloud) поэтому
      # идёт через VPN — работает, но с крюком; нужное — в myDirect. Можно и
      # автоматически: routing.domainStrategy = "IPIfNonMatch" плюс
      # dns.servers = [ "https://1.1.1.1/dns-query" ] (DoH обязателен — DNS
      # провайдера отдаёт заглушки для заблокированного); проверено в ВМ
      # 2026-10-12, но выбран список: без своего DNS и предсказуемо.
      routing.rules = [
        # мультикаст и броадкаст локалки (mDNS, LLMNR, SSDP) в туннеле не нужны
        {
          ip = [
            "224.0.0.0/4"
            "255.255.255.255/32"
            "ff00::/8"
          ];
          outboundTag = "block";
        }
        {
          ip = [ "geoip:private" ];
          outboundTag = "direct";
        }
      ]
      # Свои списки (пустой пропускается: правило без условий Xray не принимает)
      ++ lib.optional (myProxy != [ ]) {
        domain = myProxy;
        outboundTag = "proxy";
      }
      ++ lib.optional (myDirect != [ ]) {
        domain = myDirect;
        outboundTag = "direct";
      }
      ++ [
        # Warframe целиком через VPN — и к российским игрокам тоже: иначе
        # серверы DE видят адрес VPN, а пакеты игрокам уходят с домашнего IP,
        # и лобби не собирается. Игра шлёт с портов 4950/4955.
        {
          network = "udp";
          sourcePort = "4950,4955";
          outboundTag = "proxy";
        }
        {
          domain = [ "domain:warframe.com" ];
          outboundTag = "proxy";
        }
        # Через VPN, даже если адрес российский: кеши YouTube у провайдеров
        # и CDN отдаются с российских IP, а их там замедляют.
        {
          domain = [
            "geosite:youtube"
            "geosite:google"
            "geosite:telegram"
            "geosite:discord"
            "geosite:github"
            "geosite:openai"
            "geosite:twitter"
            "geosite:facebook"
            "geosite:instagram"
            "geosite:whatsapp"
          ];
          outboundTag = "proxy";
        }
        # Российское — напрямую: звонки (Телемост — UDP к серверам Яндекса по
        # IP), банки, Госуслуги. Через Нидерланды голос в звонках «роботил»:
        # UDP в туннеле едет поверх TCP, плюс крюк Россия — Амстердам — Россия.
        {
          domain = [ "geosite:category-ru" ];
          outboundTag = "direct";
        }
        {
          ip = [ "geoip:ru" ];
          outboundTag = "direct";
        }
      ];
    };
  };

  networking.firewall = {
    # Маршрут по умолчанию теперь в xray0, а ответы самого VPN-сервера
    # приходят на физический интерфейс: строгая проверка обратного пути их
    # отбрасывает, и не работает вообще ничего (проверено на ВМ). То же
    # делал модуль Happ.
    checkReversePath = "loose";
    # Из туннеля приходят только ответы и пакеты игроков на открытые
    # игрой UDP-порты (Full Cone на сервере) — как tun0 у модуля Happ.
    trustedInterfaces = [ "xray0" ];
  };

  systemd.services.xray = {
    # TUN поднимается с автоматическими маршрутами — нужна уже настроенная сеть
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    # Модуль NixOS отдаёт службе config.json; ключ — вторым файлом. Нет файла
    # — служба не стартует (systemctl status xray: «Failed to set up
    # credentials»).
    serviceConfig = {
      LoadCredential = [ "proxy.json:${proxyFile}" ];
      ExecStart = lib.mkForce (
        "${config.services.xray.package}/bin/xray run"
        + " -config \${CREDENTIALS_DIRECTORY}/config.json"
        + " -config \${CREDENTIALS_DIRECTORY}/proxy.json"
      );
    };
  };
}
