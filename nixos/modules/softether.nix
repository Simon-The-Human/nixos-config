{ pkgs, ... }:

{
  services.softether = {
    package = pkgs.experimental.softether;
    enable = true;
    dataDir = "/var/lib/softether";
  };

}
