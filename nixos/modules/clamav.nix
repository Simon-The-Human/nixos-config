{ config, lib, pkgs, ... }:

{
  services.clamav = {
    updater.enable = true;
    fangfrisch.enable = true;
  };
}
