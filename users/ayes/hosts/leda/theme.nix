{ pkgs, ... }:
let
  cursorName = "Bibata-Modern-Ice";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 14;
in
{
  home.pointerCursor = {
    enable = true;
    name = cursorName;
    package = cursorPackage;
    size = cursorSize;
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    cursorTheme = {
      name = cursorName;
      package = cursorPackage;
      size = cursorSize;
    };
    gtk4.theme = null;
  };
  qt = {
    enable = true;
    style.name = "breeze-dark";
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    gtk4.theme = null;
  };
}
