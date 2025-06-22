{ pkgs, ... }:
{
  programs.java = {
    package = pkgs.jdk17 {
      enableJavaFX = true;
    };
    enable = true;
    binfmt = true;
  };
}
