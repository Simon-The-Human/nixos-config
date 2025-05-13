{ pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    # openconnect = {
    #   # package = pkgs.networkmanager-openconnect;
    #   interfaces = {
    #     adsw_anyconnect = {
    #       gateway = "connect2.rubytech.ru";
    #       protocol = "anyconnect";
    #       user = "SSerov";
    #       passwordFile = "/var/lib/secrets/adsw-anyconnect-pw";
    #       extraOptions = {
    #         useragent = "AnyConnect";
    #       };
    #     };
    #   };
    # };
    nameservers = [
      "77.88.8.8"
      "8.8.8.8"
      "dns.nullsproxy.com"
    ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "docker0" ];
      interfaces.docker0 = {
        allowedTCPPorts = [ 2375 1337 ];
      };
      extraCommands = ''
        iptables -t nat -A POSTROUTING -s 192.168.122.0/24 -j MASQUERADE
      '';
    };
  };
}
