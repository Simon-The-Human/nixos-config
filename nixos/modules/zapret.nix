{ pkgs, ... }:
{
  services.zapret = {
    enable = true;
    # udpSupport = true;
    whitelist = [
      "youtube.com"
      "googlevideo.com"
      "ytimg.com"
      "youtu.be"
    ];
    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
      "--dpi-desync-repeats=6"
      "--dpi-desync-any-protocol"
    ];
  };
}
