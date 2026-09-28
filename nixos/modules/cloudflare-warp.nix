{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.cloudflare-warp = {
    enable = true;
  };
}
