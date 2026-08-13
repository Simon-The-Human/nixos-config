{
  config,
  lib,
  pkgs,
  ...
}:

{
  security.pki.certificateFiles = [
    ./mintsifry_certs/russian_trusted_root_ca_pem.crt
    ./mintsifry_certs/russian_trusted_sub_ca_pem.crt
    ./mintsifry_certs/russian_trusted_sub_ca_2024_pem.crt
    ./mintsifry_certs/russian_trusted_root_ca_gost_2025_pem.crt
    ./mintsifry_certs/russian_trusted_sub_ca_gost_2025_pem.crt
  ];
}
