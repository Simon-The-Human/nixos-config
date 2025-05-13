{ config, pkgs, nixpkgs-unstable, nixpkgs-experimental, ... }:
let
  unstable = import nixpkgs-unstable { inherit (config.nixpkgs) config; };
  experimental = import nixpkgs-experimental { inherit (config.nixpkgs) config; };
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
    qemu
    # quickemu

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist
    unstable.nwg-look

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
