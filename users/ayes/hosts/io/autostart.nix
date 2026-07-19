{
  services.autostart = {
    enable = true;
    apps = {
      steam = {
        description = "Steam";
        command = "/run/current-system/sw/bin/steam -silent";
        requiresNetwork = true;
      };
      vesktop = {
        description = "Vesktop";
        command = "/etc/profiles/per-user/ayes/bin/vesktop";
        requiresNetwork = true;
      };

      wallpaper-engine = {
        description = "Wallpapers";
        command =
          "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --silent "
          + "--screen-root=DP-1 --bg 3731183557 "
          + "--screen-root=HDMI-A-1 --bg 2473589076 "
          + "--screen-root=DP-2 --bg 2217899039";
      };

      /*
        wp-dp-1 = {
          description = "Wallpaper for DP-1";
          command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=DP-1 3731183557 --silent";
        };

        wp-hdmi-a-1 = {
          description = "Wallpaper for HDMI-A1";
          command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=HDMI-A-1 2473589076";
        };

        wp-dp-2 = {
          description = "Wallpaper for DP-2";
          command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=DP-2 2217899039";
        };
      */
    };
  };
}
