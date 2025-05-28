{ config, lib, pkgs, ... }:

{
  xdg.desktopEntries.mattermost = {
    name = "Mattermost";
    exec = "mattermost-desktop -- %u";
    mimeType = [ "x-scheme-handler/mattermost" ];
    settings = {
      Terminal = "false";
      Type = "Application";
      StartupWMClass = "Mattermost";
    };
  };
}
