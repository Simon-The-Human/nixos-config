{ ... }:

{
  services.happ = {
    enable = false;
    forceXwayland = true;
    # forceSoftwareRendering = true;  # если UI поедет
  };
}
