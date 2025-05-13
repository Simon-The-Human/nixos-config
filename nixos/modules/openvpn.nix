{ config, lib, pkgs, ... }:

{
  services.openvpn.servers = {
    officeVPN  = { config = '' config /home/simon/ovpn/s.serov@arenadata.io.ovpn''; };
    # homeVPN    = { config = '' config /root/nixos/openvpn/homeVPN.conf ''; };
  };
}
