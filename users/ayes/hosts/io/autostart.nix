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

      wp-dp-1 = {
        description = "Wallpaper for DP-1";
        command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=DP-1 2459477453";
      };

      wp-hdmi-a-1 = {
        description = "Wallpaper for HDMI-A1";
        command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=HDMI-A1 2594686226";
      };

      wp-dp-2 = {
        description = "Wallpaper for DP-2";
        command = "/etc/profiles/per-user/ayes/bin/linux-wallpaperengine --screen-root=DP-2 2744538407";
      };
    };
  };
}
