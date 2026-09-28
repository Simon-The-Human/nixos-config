{ config, pkgs, ... }:

{
  services.zapret = {
    enable = true;

    # Перехватываем P2P UDP-порты
    udpSupport = true;
    udpPorts = [
      "4950,4955"
      "3960,3962"
    ];

    # Перехватываем HTTP/HTTPS (лаунчер и авторизация)
    httpSupport = true;

    # Домены, к которым применяется десинхронизация
    whitelist = [
      "warframe.com"
      "digitalextremes.com"
    ];

    # Аргументы nfqws
    params = [
      "--dpi-desync=fake,disorder2"
      "--dpi-desync-ttl=1"
      "--dpi-desync-autottl=2"
      "--dpi-desync-repeats=2"
      "--dpi-desync-any-protocol=1" # Ключевой флаг: заставляет nfqws обрабатывать кастомный UDP/TCP трафик Warframe
    ];
  };
}
