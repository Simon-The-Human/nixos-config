{ pkgs, ... }:

{
  services.softether = {
    package = pkgs.softether;
    enable = true;
  };
}
