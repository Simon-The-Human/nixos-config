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
  xdg = {
    # configFile."xdg-desktop-portal-termfilechooser/config" = {
    #   text = ''
    #     [filechooser]
    #     cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooster/ranger-wrapper.sh
    #     env=TERMCMD='alacritty -T "filechooser"'
    #   '';
    # };
    #
    # desktopEntries.mattermost = {
    #   name = "Mattermost";
    #   exec = "mattermost-desktop -- %u";
    #   mimeType = [ "x-scheme-handler/mattermost" ];
    #   settings = {
    #     Terminal = "false";
    #     Type = "Application";
    #     StartupWMClass = "Mattermost";
    #   };
    # };
    };
  };
}
