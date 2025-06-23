{ pkgs, ... }:
{
  programs.java = {
    # package = (pkgs.jdk21.override
    #   {
    #   enableJavaFX = true;
    # });
    package = pkgs.jdk8;
    enable = true;
    binfmt = true;
  };
}
