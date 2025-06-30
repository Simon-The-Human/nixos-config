{ config, pkgs, ... }:
let
  myHostList = [
    "cloudflare-ech.com"
    "dis.gd"
    "discord-attachments-uploads-prd.storage.googleapis.com"
    "discord.app"
    "discord.co"
    "discord.com"
    "discord.design"
    "discord.dev"
    "discord.gift"
    "discord.gifts"
    "discord.gg"
    "discord.media"
    "discord.new"
    "discord.store"
    "discord.status"
    "discord-activities.com"
    "discordactivities.com"
    "discordapp.com"
    "discordapp.net"
    "discordcdn.com"
    "discordmerch.com"
    "discordpartygames.com"
    "discordsays.com"
    "discordsez.com"
    "yt3.ggpht.com"
    "yt4.ggpht.com"
    "yt3.googleusercontent.com"
    "googlevideo.com"
    "jnn-pa.googleapis.com"
    "stable.dl2.discordapp.net"
    "wide-youtube.l.google.com"
    "youtube-nocookie.com"
    "youtube-ui.l.google.com"
    "youtube.com"
    "youtubeembeddedplayer.googleapis.com"
    "youtubekids.com"
    "youtubei.googleapis.com"
    "youtu.be"
    "yt-video-upload.l.google.com"
    "ytimg.com"
    "ytimg.l.google.com"
    "frankerfacez.com"
    "ffzap.com"
    "betterttv.net"
    "7tv.app"
    "7tv.io"
  ];
in {
  disabledModules = [
    "services/networking/zapret.nix"
  ]; # необходимо если версия nixpkgs новее 5a5c04d

  imports = [ ./zapret_service.nix ];

  services.zapret = {
    enable = true;
    mode = "nfqws";

    settings = ''
      SET_MAXELEM=522288
      IPSET_OPT="hashsize 262144 maxelem $SET_MAXELEM"
      IP2NET_OPT4="--prefix-length=22-30 --v4-threshold=3/4"
      IP2NET_OPT6="--prefix-length=56-64 --v6-threshold=5"
      AUTOHOSTLIST_RETRANS_THRESHOLD=3
      AUTOHOSTLIST_FAIL_THRESHOLD=3
      AUTOHOSTLIST_FAIL_TIME=60
      AUTOHOSTLIST_DEBUGLOG=0
      MDIG_THREADS=30
      GZIP_LISTS=1
      QUIC_PORTS=50000-65535
      MODE_HTTP=1
      MODE_HTTP_KEEPALIVE=0
      MODE_HTTPS=1
      MODE_QUIC=1
      MODE_FILTER=none
      DESYNC_MARK=0x40000000
      DESYNC_MARK_POSTNAT=0x20000000
      WF_TCP="443-65535,80,443,50000-65535"
      WF_UDP="443-65535,443,50000-65535"
      FILTER_UDP="443,50000-65535"
      FILTER_TCP="80,443"
      DPI_DESYNC="fake,split2,tamper,autottl=2,fooling=md5sig,disorder2"
      DPI_DESYNC_UDPLEN_INCREMENT=10
      DPI_DESYNC_REPEATS=6
      DPI_DESYNC_UDPLEN_PATTERN=0xDEADBEEF
      # DPI_DESYNC_FAKE_QUIC="quic_initial_www_google_com.bin"
      # DPI_DESYNC_FAKE_TLS="tls_clienthello_www_google_com.bin"
      HOSTLIST_WHITELIST="${builtins.concatStringsSep " " myHostList}"
    '';
  };
}
