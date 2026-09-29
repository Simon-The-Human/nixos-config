{ pkgs, ... }:

let
  updateResolvedScript = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
in
{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
    nameservers = [ "192.168.1.1" ];

    firewall = {
      enable = true;
      allowedUDPPorts = [
        4950
        4955
        3960
        3962
      ];
      allowedTCPPorts = [ 6695 ]; # Игровой чат Warframe

      trustedInterfaces = [ "docker0" ];
      interfaces.docker0 = {
        allowedTCPPorts = [
          2375
          1337
        ];
      };

      # Расширенный extraCommands: объединяет NAT для KVM/libvirt и TPROXY для Xray
      extraCommands = ''
        # --- Существующий NAT ---
        iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE

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
    };
  };

  # Включение forwarding в ядре
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [ update-systemd-resolved ];

  # --- OpenVPN ---
  services.openvpn.servers.officeVPN = {
    config = ''
      config /home/simon/ovpn/s.serov@arenadata.io.ovpn
      script-security 2
      up ${updateResolvedScript}
      up-restart
      down ${updateResolvedScript}
      down-pre
    '';
    updateResolvConf = false;
  };

  # --- Права и конфигурация Xray ---
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

  services.xray = {
    enable = true;
    settings = {
      log.loglevel = "warning";
      inbounds = [
        {
          tag = "transparent-in";
          port = 12345;
          protocol = "dokodemo-door";
          settings = {
            network = "tcp,udp";
            followRedirect = true;
          };
          streamSettings.sockopt.tproxy = "tproxy";
        }
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
              address = "89.124.114.14";
              port = 443;
              users = [
                {
                  id = "ВАШ_UUID_ЗДЕСЬ";
                  encryption = "none";
                  level = 8;
                }
              ];
            }
          ];
          streamSettings = {
            network = "xhttp";
            security = "reality";
            realitySettings = {
              fingerprint = "chrome";
              publicKey = "ВАШ_PUBLIC_KEY_ЗДЕСЬ";
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
            sockopt.mark = 255; # Обязательная метка, чтобы Xray не закольцовывал свой трафик
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
