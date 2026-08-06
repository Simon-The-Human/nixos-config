{ config, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
  };
  environment.systemPackages = with pkgs; [
    experimental.brave
    emacs
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    })
    git
    gcc
    mattermost-desktop
    home-manager
    qemu_full

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist
    unstable.nwg-look

    # WM stuff
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-utils

    # Sound
    pamixer

    chez
    experimental.gparted-full
    experimental.parted
    openvpn
    networkmanager-openvpn
    # unstable.amnezia-vpn
    openconnect
    spice-vdagent
    libtool
    # (jdk17.override {
    #   enableJavaFX = true;}
    # )
    nixfmt
    openldap
    cyrus_sasl
    zapret
    minikube
    gnumake
    experimental.racket
    # python311
    # python312
    python313
    python314
    unstable.poetry

    # GPU stuff
    glaxnimate
  ];
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
    fira-code
    fira-code-symbols
  ];
}
