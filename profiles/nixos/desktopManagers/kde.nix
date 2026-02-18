{ pkgs
, lib
, ...
}:
{
  services = {
    xserver.enable = false;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Ice"; # the cursor name here matters
          # I would always go check the source nix file
          # to see how the maintainers built and named it
          CursorSize = 20;
        };
      };
    };

    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs.kdePackages; [
    elisa
    plasma-integration
    kolourpaint
    kcalc
    isoimagewriter

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
