{ ... }:

{
  services.happ = {
    enable = true;
    forceXwayland = true;
    # forceSoftwareRendering = true;  # если UI поедет
  };
}
