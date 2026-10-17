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
        xorg.libXext
        xorg.libX11
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXxf86vm
        libGL
        glfw
        openal
        zlib
        glib
        udev # на всякий случай для контроллеров/LWJGL
      ];

    # Скрипт запуска: переходим в корень сборки и стартуем лаунчер
    runScript = pkgs.writeShellScript "tfc-launcher-start" ''
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
