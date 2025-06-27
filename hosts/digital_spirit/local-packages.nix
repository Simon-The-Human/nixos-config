{ config, pkgs, ... }: {
  nixpkgs.config = { allowUnfree = true; };
  environment.systemPackages = with pkgs; [
    emacs
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    })
    git
    gcc
    kdenlive
    mattermost-desktop
    home-manager
    qemu_full

    # Wayland stuff
    xwayland
    wl-clipboard
    cliphist
    unstable.nwg-look

    # WM stuff
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-utils

    # Sound
    pipewire
    pulseaudio
    pamixer

    chez
    openvpn
    networkmanager-openvpn
    # unstable.amnezia-vpn
    openconnect
    spice-vdagent
    libtool
    # (jdk17.override {
    #   enableJavaFX = true;}
    # )
    # virtualbox
    # qemu_full
    vagrant
    nixfmt-classic
    openldap
    cyrus_sasl
    zapret
    minikube
    gnumake
    racket
    python310
    python311
    python311Packages.requests
    python312
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
