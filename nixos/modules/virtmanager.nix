{ pkgs, ... }: {
  programs = {
    virt-manager.enable = true;
    virt-manager.package = pkgs.virt-manager;
  };
  virtualisation = {
    # virtualbox.host = {
    #   enable = true;
    #   enableExtensionPack = true;
    # };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      daemon.settings = {
        hosts = [ "unix:///var/run/docker.sock" "fd://" "tcp://0.0.0.0:2375" ];
      };
    };
  };
}
