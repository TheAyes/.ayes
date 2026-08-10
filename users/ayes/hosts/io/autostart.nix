{ pkgs, ... }: {
  services.autostart = {
    enable = true;
    apps = {
      steam = {
        description = "Steam";
        command = "${pkgs.steam}/bin/steam -silent";
        requiresNetwork = true;
      };
      vesktop = {
        description = "Vesktop";
        command = "${pkgs.bash}/bin/bash -c 'sleep 2s && ${pkgs.vesktop}/bin/vesktop'";
        requiresNetwork = true;
      };

      wallpaper-engine = {
        description = "Wallpapers";
        command =
          "${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine --silent "
          + "--screen-root=DP-1 --bg 2799877694 "
          + "--screen-root=HDMI-A-1 --bg 2473589076 "
          + "--screen-root=DP-2 --bg 2217899039";
      };
    };
  };
}
