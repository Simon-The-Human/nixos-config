{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "python-2.7.18.8" ];

  home.packages = with pkgs; [
    # Packages in each category are sorted alphabetically

    # Desktop apps
    anki
    # code-cursor
    imv
    mpv
    obs-studio
    # obsidian
    pavucontrol
    alacritty
    audacity
    jan
    unstable.telegram-desktop
    mattermost-desktop
    mmctl
    # unstable.steam-run
    # discord
    vesktop
    # unstable.yandex-browser
    obs-studio
    rofi
    wofi
    mpv
    unstable.luanti
    kdenlive
    gparted
    # obsidian
    zoom-us
    qbittorrent
    libreoffice
    unstable.freecad-wayland
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
    graphviz
    # jetbrains.pycharm-community-src
    vscode
    nodejs
    poetry
    pyenv
    sqlite
    vim

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
    unstable.openfortivpn-webview
    packer
    swww
    tree
    unzip
    wget
    yt-dlp
    unstable.yandex-cloud
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

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
  ];
}
