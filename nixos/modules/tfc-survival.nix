{
  config,
  lib,
  pkgs,
  ...
}:

let
  tfcLauncherScript = pkgs.writeShellScriptBin "tfc-survival-launcher" ''
    cd /home/simon/tfc-survival
    exec java -jar launcher.jar
  '';
in
{
  environment.systemPackages = [
    tfcLauncherScript
  ];
}
