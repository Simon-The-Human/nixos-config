{ config, pkgs, ... }:

let
  nixos-unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    anki
    # code-cursor
    imv
    mpv
    obs-studio
    obsidian
    pavucontrol
    alacritty
    audacity
    jan
    nixos-unstable.telegram-desktop
    mattermost-desktop
    mmctl
    # unstable.steam-run
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = false;
    })
    # discord
    vesktop
    # nixos-unstable.yandex-browser
    obs-studio
    rofi
    wofi
    mpv
    nixos-unstable.luanti
    kdenlive
    gparted
    # obsidian
    zoom-us
    qbittorrent
    libreoffice
    nixos-unstable.freecad-wayland
    yandex-disk
    unstable.yandex-music

    # CLI utils
    bc
    bottom
    brightnessctl
    cliphist
    ffmpeg
    ffmpegthumbnailer
    fzf
    git-graph
    grimblast
    htop
    hyprpicker
    ntfs3g
    mediainfo
    microfetch
    playerctl
    ripgrep
    showmethekey
    silicon
    udisks
    ueberzugpp
    unzip
    w3m
    wget
    wl-clipboard
    wtype
    yt-dlp
    zip

    # Coding stuff
    allure
    ansible
    cachix
    cmake
    direnv
    emacs
    emacsPackages.vterm
    emacsPackages.fira-code-mode
    gcc
    minikube
    gnumake
    graphviz
    # jetbrains.pycharm-community-src
    vscode
    nodejs
    poetry
    pyenv
    python
    python39
    python310
    python311
    python311Packages.requests
    racket
    sqlite
    vim

    # WM stuff
    libsForQt5.xwaylandvideobridge
    libnotify
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland

    # CLI utils
    nixos-unstable.awscli
    bluez
    bluez-tools
    brightnessctl
    dig
    docker-compose
    cava
    f3
    fastfetch
    fd
    ffmpeg
    file
    git
    htop
    kafkactl
    lazygit
    guestfs-tools
    light
    lux
    mediainfo
    neofetch
    nix-index
    ntfs3g
    openssl
    pandoc
    parted
    pwgen
    ranger
    ripgrep
    scrot
    systemd
    openssh
    nixos-unstable.openfortivpn-webview
    packer
    swww
    tree
    unzip
    wget
    yt-dlp
    nixos-unstable.yandex-cloud
    zip
    zram-generator

    # GUI utils
    dmenu
    feh
    gromit-mpx
    imv
    mako
    screenkey
    mongodb-compass

    # Other
    bemoji
    nix-prefetch-scripts

    # WMs and stuff
    herbstluftwm
    hyprland
    hyprcursor
    seatd
    xdg-desktop-portal-hyprland
    polybar
    waybar
    xdg-utils

    # Sound
    pipewire
    pulseaudio
    pamixer

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
    openvpn
    networkmanager-openvpn
    # nixos-unstable.amnezia-vpn
    openconnect
    home-manager
    spice-vdagent
    libtool
    papirus-nord
    # (jdk17.override {
    #   enableJavaFX = true;}
    # )
    # virtualbox
    # qemu_full
    vagrant
    nixfmt-classic
    openldap
    update-systemd-resolved
    cyrus_sasl
    zapret
  ];
}
