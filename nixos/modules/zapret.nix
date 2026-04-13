{ config, pkgs, ... }:

{
  services.zapret = {
    enable = true;
    udpSupport = true;
    params = [

    ];
    blacklist = [
      "0.0.0.0/8"
      "10.0.0.0/8"
      "127.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "169.254.0.0/16"
      "224.0.0.0/4"
      "100.64.0.0/10"
      "::1"
      "fc00::/7"
      "fe80::/10"
      "pusher.com"
      "live-video.net"
      "ttvnw.net"
      "twitch.tv"
      "mail.ru"
      "citilink.ru"
      "yandex.com"
      "nvidia.com"
      "donationalerts.com"
      "vk.com"
      "yandex.kz"
      "mts.ru"
      "multimc.org"
      "ya.ru"
      "dns-shop.ru"
      "habr.com"
      "3dnews.ru"
      "sberbank.ru"
      "ozon.ru"
      "wildberries.ru"
      "microsoft.com"
      "microsoftonline.com"
      "live.com"
      "minecraft.net"
      "xboxlive.com"
      "akamaitechnologies.com"
      "msi.com"
      "2ip.ru"
      "yandex.ru"
      "boosty.to"
      "tanki.su"
      "lesta.ru"
      "korabli.su"
      "tanksblitz.ru"
      "reg.ru"
      "epicgames.dev"
      "epicgames.com"
      "unrealengine.com"
      "riotgames.com"
      "riotcdn.net"
      "leagueoflegends.com"
      "playvalorant.com"
      "marketplace.visualstudio.com"
    ];
  };
}
