{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.8"
    "pnpm-10.29.2"
  ];

  home.packages = with pkgs; [
    (writeShellScriptBin "steam" ''
      exec ${pkgs.steam}/bin/steam -cef-disable-gpu "$@"
    '')
    # Desktop apps
    anki
    imv
    mpv
    obs-studio
    # obsidian
    pavucontrol
    alacritty
    audacity
    jan
    experimental.telegram-desktop
    mmctl
    obs-studio
    fuzzel
    xwayland-satellite
    swaynotificationcenter
    mpv
    mindustry-wayland
    nautilus
    unstable.luanti
    zoom-us
    qbittorrent
    libreoffice
    unstable.freecad-wayland
    experimental.yandex-disk
    experimental.yandex-music
    vesktop

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
    unrar
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
    experimental.emacs
    experimental.emacsPackages.vterm
    graphviz
    jupyter
    # jetbrains.pycharm-community-src
    # vscode
    uv
    pyenv
    sqlite
    vim
    mpls

    # CLI utils
    unstable.awscli
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
    lux
    mediainfo
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
    unstable.openfortivpn-webview
    packer
    awww
    tree
    unzip
    wget
    yt-dlp
    experimental.yandex-cloud
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
    polybar
    waybar
    xdg-utils

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
  ];
}
