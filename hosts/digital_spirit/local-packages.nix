{ config, pkgs, ... }:
let
  nixos-unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/d89fc19e)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/a39ed32a)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = with pkgs; [
    gcc
    kdenlive
    mattermost-desktop
    # jre8
    # qemu
    # quickemu

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist
    nixos-unstable.nwg-look

    # GPU stuff
    amdvlk
    # rocm-opencl-icd
    glaxnimate
  ];
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
