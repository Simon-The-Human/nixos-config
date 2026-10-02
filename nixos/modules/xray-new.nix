{ config, pkgs, ... }:

# Xray вместо Happ: весь трафик системы через VLESS-сервер (Нидерланды).
#
# TUN, а не TPROXY: Xray сам заводит интерфейс xray0 и маршруты в него и сам
# привязывает свои соединения к физическому интерфейсу, чтобы не зациклиться.
# iptables не нужен. Happ при этом должен быть выключен — два TUN мешают друг
# другу.
let
  server = {
    address = "89.124.114.14";
    id = "1fbedadd-16de-46be-ad38-dadd1c8406ac"; # ключ semen_comp
    publicKey = "lxkBfoVrpsv-fGbC1efKPi7rGf-cy8K6zNkbmciciWc";
    shortId = "d91e03d6273ec76a";
    path = "/9fcac0df557e";
    serverName = "nl.ctpejikuh.net";
  };
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
          # Адрес назначения по имени сайта из TLS/HTTP: сервер сам
          # разрезолвит его, и подменённый провайдером DNS не помешает.
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
            ];
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
        {
          tag = "proxy";
          protocol = "vless";
          settings.vnext = [
            {
              inherit (server) address;
              port = 443;
              users = [
                {
                  inherit (server) id;
                  encryption = "none";
                }
              ];
            }
          ];
          streamSettings = {
            network = "xhttp";
            security = "reality";
            realitySettings = {
              inherit (server) publicKey shortId serverName;
              fingerprint = "chrome";
            };
            xhttpSettings = {
              inherit (server) path;
              mode = "stream-one";
              # Все соединения — внутри одного-двух TLS. Без этого на каждое
              # соединение открывается своё TLS, а пачки параллельных TLS к
              # зарубежному IP ТСПУ «замораживает».
              extra.xmux = {
                maxConcurrency = "16-32";
                hMaxRequestTimes = "600-900";
                hMaxReusableSecs = "1800-3000";
              };
            };
          };
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

      # Всё, что не попало в правила, — в первый outbound (proxy)
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

  # TUN поднимается с автоматическими маршрутами — нужна уже настроенная сеть
  systemd.services.xray = {
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
