{ homeStateVersion, user, ... }: {
  imports = [
    ./modules
    ./home-packages.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    sessionVariables = {
      XDG_CURRENT_DESKTOP = "GNOME";
    };
  };
}
