{ config, pkgs, ... }:

{
  networking.firewall.extraCommands = ''
    # --- Настройка TPROXY для Xray ---
    # 1. Правила маршрутизации ядра для fwmark 1
    ip rule add fwmark 1 table 100 2>/dev/null || true
    ip route add local default dev lo table 100 2>/dev/null || true

    # 2. Цепочка перехвата входящего/транзитного трафика
    iptables -t mangle -N XRAY 2>/dev/null || iptables -t mangle -F XRAY
    iptables -t mangle -A XRAY -m mark --mark 255 -j RETURN # Игнорируем пакеты самого Xray
    iptables -t mangle -A XRAY -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A XRAY -d 10.0.0.0/8 -j RETURN      # Сохраняем доступ к Office VPN / LAN
    iptables -t mangle -A XRAY -d 172.16.0.0/12 -j RETURN   # Сохраняем Docker подсети
    iptables -t mangle -A XRAY -d 192.168.0.0/16 -j RETURN  # Локалка
    iptables -t mangle -A XRAY -p tcp -j TPROXY --on-port 12345 --tproxy-mark 1
    iptables -t mangle -A XRAY -p udp -j TPROXY --on-port 12345 --tproxy-mark 1
    iptables -t mangle -A PREROUTING -j XRAY

    # 3. Цепочка маркировки локального трафика системы
    iptables -t mangle -N XRAY_MARK 2>/dev/null || iptables -t mangle -F XRAY_MARK
    iptables -t mangle -A XRAY_MARK -m mark --mark 255 -j RETURN
    iptables -t mangle -A XRAY_MARK -d 127.0.0.0/8 -j RETURN
    iptables -t mangle -A XRAY_MARK -d 10.0.0.0/8 -j RETURN
    iptables -t mangle -A XRAY_MARK -d 172.16.0.0/12 -j RETURN
    iptables -t mangle -A XRAY_MARK -d 192.168.0.0/16 -j RETURN
    iptables -t mangle -A XRAY_MARK -p tcp -j MARK --set-mark 1
    iptables -t mangle -A XRAY_MARK -p udp -j MARK --set-mark 1
    iptables -t mangle -A OUTPUT -j XRAY_MARK
  '';
  # 2. Выдаем xray права ядра для прозрачного проксирования (TPROXY)
  systemd.services.xray = {
    serviceConfig = {
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      PrivateNetwork = false;
    };
  };

  # 3. Конфигурация Xray
  services.xray = {
    enable = true;
    settings = {
      log = {
        loglevel = "warning";
      };

      inbounds = [
        # Входящий интерфейс для прозрачного проксирования L3 (TPROXY)
        {
          tag = "transparent-in";
          port = 12345;
          protocol = "dokodemo-door";
          settings = {
            network = "tcp,udp";
            followRedirect = true;
          };
          streamSettings = {
            sockopt = {
              tproxy = "tproxy"; # Включает перехват L3-трафика на уровне nftables/iptables
            };
          };
        }
        # SOCKS5 входящий (для браузёра или приложений)
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
          settings = {
            vnext = [
              {
                address = "89.124.114.14"; # IP вашего VPS
                port = 443;
                users = [
                  {
                    id = "1fbedadd-16de-46be-ad38-dadd1c8406ac"; # Вставьте ваш UUID
                    encryption = "none";
                    level = 8;
                  }
                ];
              }
            ];
          };
          streamSettings = {
            network = "xhttp";
            security = "reality";
            realitySettings = {
              fingerprint = "chrome";
              publicKey = "lxkBfoVrpsv-fGbC1efKPi7rGf-cy8K6zNkbmciciWc"; # Вставьте ваш publicKey
              serverName = "nl.ctpejikuh.net";
              shortId = "d91e03d6273ec76a";
            };
            xhttpSettings = {
              mode = "stream-one";
              path = "/9fcac0df557e";
              scMaxConcurrentPosts = 10;
              scMaxEachPostBytes = 1000000;
              scMinPostsIntervalMs = 30;
            };
            sockopt = {
              mark = 255; # Метка для предотвращения закольцовывания трафика самого Xray
            };
          };
        }
        {
          tag = "direct";
          protocol = "freedom";
        }
      ];
    };
  };
}
