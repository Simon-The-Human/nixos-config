{
  config,
  lib,
  pkgs,
  ...
}:

let
  updateResolvedScript = "${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved";
in
{

  # --- OpenVPN ---
  services.openvpn.servers.officeVPN = {
    config = ''
      config '/home/simon/ovpn/s.serov@arenadata.io (1).ovpn'
      script-security 2
      up ${updateResolvedScript}
      up-restart
      down ${updateResolvedScript}
      down-pre
    '';
    updateResolvConf = false;
  };
}
