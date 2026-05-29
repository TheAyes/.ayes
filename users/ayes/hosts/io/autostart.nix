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
    };
  };
}
