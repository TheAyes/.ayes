{lib, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.uwsm = {
    enable = lib.mkDefault true;
  };
}
