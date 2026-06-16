{ pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";

    nameservers = [ "192.168.1.1" ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "docker0" ];
      interfaces.docker0 = { allowedTCPPorts = [ 2375 1337 ]; };
      extraCommands = ''
        iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
      '';
    };
  };

  services.resolved.enable = true;

  services.openvpn.servers.officeVPN = {
    config = "config /home/simon/ovpn/s.serov@arenadata.io.ovpn";
    updateResolvConf = false;
  };

}
