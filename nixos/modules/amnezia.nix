{ config, lib, pkgs, ... }:
let cfg = config.programs.amnezia;
in {
  options.programs.amnezia = {
    enable = lib.mkEnableOption "The AmneziaVPN client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.amnezia ];
    services.dbus.packages = [ pkgs.amnezia ];
    services.resolved.enable = true;

    systemd = {
      packages = [ pkgs.amnezia ];
      services."AmneziaVPN".wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ sund3RRR ];
}
