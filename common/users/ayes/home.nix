{pkgs, ...}: {
  imports = [
    ./programs/git.nix
    ./programs/btop.nix

    ../../../presets/home-manager/programs/fish.nix
    ../../../presets/home-manager/programs/direnv.nix
  ];

  home = {
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      dotIcons.enable = true;

      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    sessionVariables = {
      GIT_MERGE_AUTOEDIT = "no";
    };

    packages = with pkgs; [
      # Documentation and Writing
      obsidian
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "adwaita-dark";
    };
  };
}
