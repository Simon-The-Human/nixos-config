{
  config,
  lib,
  pkgs,
  ...
}:

let
  tfcLauncherEnv = pkgs.buildFHSEnv {
    name = "tfc-survival-launcher";

    # Пакеты, которые будут доступны процессам внутри песочницы по классическим путям
    targetPkgs =
      pkgs: with pkgs; [
        libX11
        libXext
        libXrender
        libXtst
        libXi
        libXcursor
        libXrandr
        libXxf86vm
        libXinerama
        libXau
        libXdmcp

        libGL
        glfw
        openal
        zlib
        glib
        udev
        mesa
        mesa-demos
        libglvnd
        xrandr
      ];

    # Скрипт запуска: переходим в корень сборки и стартуем лаунчер
    runScript = pkgs.writeShellScript "tfc-launcher-start" ''
      export DISPLAY="''${DISPLAY:-:0}"
      export XAUTHORITY="''${XAUTHORITY:-$HOME/.Xauthority}"
      cd /home/simon/tfc-survival
      exec java -jar launcher.jar
    '';
  };
in
{
  environment.systemPackages = [
    tfcLauncherEnv
  ];
}
