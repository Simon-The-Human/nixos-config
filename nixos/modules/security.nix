{
  config,
  lib,
  pkgs,
  ...
}:

{
  security.pki.certificateFiles = [
    ./russian_trusted_root_ca_pem.crt
    ./russian_trusted_sub_ca_pem.crt
    ./russian_trusted_sub_ca_2024_pem.crt
    ./russian_trusted_root_ca_gost_2025_pem.crt
    ./russian_trusted_sub_ca_gost_2025_pem.crt
  ];
}
