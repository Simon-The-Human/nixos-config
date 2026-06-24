{ config, pkgs, ... }:

{
  # Включаем поддержку TeX Live через Home Manager
  programs.texlive = {
    enable = true;
    # Выберите базовую схему (medium — хороший баланс)
    # или full, если нужно всё
    extraPackages = tpkgs:
      with tpkgs; [
        # Основные коллекции и пакеты
        scheme-medium
        # Дополнительные пакеты, которых нет в схеме
        collection-langcyrillic
        # Если нужны отдельные пакеты, можно добавить их здесь
        # latexmk
        # xetex
        # l3packages
        # siunitx
      ];
  };
}
