{ pkgs, lib, ... }:
{
  services = {
    xserver.enable = false;
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

  };

  environment.systemPackages = with pkgs.kdePackages; [
    plasma-integration
    kolourpaint
    kcalc

    pkgs.unrar
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  qt.platformTheme = lib.mkForce "kde";

  xdg.icons.fallbackCursorThemes = [ "breeze_cursors" ];
}
