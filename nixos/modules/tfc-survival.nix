{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Создаем изолированное FHS-окружение специально для лаунчера TFC
  tfcFhsEnv = pkgs.buildFHSUserEnv {
    name = "tfc-survival-launcher";
    targetPkgs =
      pkgs: with pkgs; [
        # Системные либы для Java и графики (LWJGL, X11, OpenGL)
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
        udev # на всякий случай для контроллеров/lwjgl
      ];
    # Команда, которая выполнится при вызове созданной обертки
    runScript = "cd /home/simon/tfc-survival && java -jar launcher.jar";
  };
in
{
  # Добавляем команду tfc-survival-launcher в глобальный PATH хоста
  environment.systemPackages = [
    tfcFhsEnv
  ];

  # При желании здесь же можно настроить права, правила udev для геймпадов
  # или другие системные штуки, если они понадобятся.
}
