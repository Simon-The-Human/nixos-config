{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gcc
    kdenlive
    # jetbrains.pycharm-professional
    # jre8
    # qemu
    # quickemu
  ];
}
