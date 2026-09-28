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
      allowedUDPPorts = [
        4950
        4955
        3960
        3962
      ];
      allowedTCPPorts = [ 6695 ]; # Игровой чат Warframe
      enable = true;
      trustedInterfaces = [ "docker0" ];
      interfaces.docker0 = {
        allowedTCPPorts = [
          2375
          1337
        ];
      };
      extraCommands = ''
        iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
      '';
    };
  };

  services.resolved.enable = true;

  environment.systemPackages = with pkgs; [ update-systemd-resolved ];

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
