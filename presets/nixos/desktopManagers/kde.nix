{ pkgs, ... }: {
  services = {
    xserver.enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    kolourpaint
    kcalc
  ];

  xdg.icons.fallbackCursorThemes = [ "breeze_cursors" ];
}
