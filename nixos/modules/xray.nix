{ config, pkgs, ... }:

{
  # Включаем Xray службу
  services.xray = {
    enable = true;

    # Путь к вашему замаскированному JSON-конфигу или прямое описание settings
    settingsFile = "/etc/xray/config.json";
  };

  # Выдаем службе xray необходимые Linux capabilities для создания tun-интерфейса
  systemd.services.xray = {
    serviceConfig = {
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      # Отключаем изоляцию файловой системы/сети, если она мешает TUN
      PrivateNetwork = false;
    };
  };

  # Разрешаем форвардинг пакетов на уровне ядра
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };
}
