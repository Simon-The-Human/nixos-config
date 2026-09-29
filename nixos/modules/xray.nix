{ config, pkgs, ... }:

{
  # 1. Разрешаем форвардинг пакетов на уровне ядра
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

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
