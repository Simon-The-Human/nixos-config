{
  config,
  lib,
  pkgs,
  ...
}:

{
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
    portal = {
      enable = true;
      config = {
        # default = {
        #   "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
        # };
        default = {
          "org.freedesktop.impl.portal.FileChooser" = "gnome";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";

        };
        # Для композитора niri (необязательно, но пусть будет)
        niri = {
          "org.freedesktop.impl.portal.FileChooser" = "gnome";
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        xdg-desktop-portal-termfilechooser
      ];
    };
  };
}
