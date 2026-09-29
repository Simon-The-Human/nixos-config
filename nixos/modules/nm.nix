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
        iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
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

}
