{ pkgs, user, ... }: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      ${user} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "input"
          "libvirtd"
          "docker"
          "vboxusers"
          "syncthing"
          "gitlab-runner"
        ];
      };
    };
  };

  services.getty.autologinUser = user;
}
