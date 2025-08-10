{ user
, pkgs
, system
, inputs
, ...
}: {
  imports = [
    ../../../../common/users/ayes/home.nix

    ./hyprland.nix
    ./nixcord.nix
    ./kitty.nix
  ];

  home = {
    packages = with pkgs; [
      # Gaming
      #xivlauncher
      (prismlauncher.override {
        jdks = [ graalvm-ce ];
      })

      heroic
      lutris

      # Music Production
      bitwig-studio

      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      jetbrains.rider

      inputs.godot-fix.legacyPackages.${system}.godot-mono

      bun
      uv
      ruff
      #python312Full
      #python312Packages.pip
      #python312Packages.tkinter
      claude-code

      dotnetCorePackages.dotnet_9.sdk

      #revolt-desktop
      blockbench
      proton-pass

      inputs.zen-browser.packages.${system}.default
    ];

    file = {
      /*"xiv-config" = {
        enable = true;

        source = ./external/xlcore;
        target = ".xlcore";
      };*/
    };
  };

  programs = {
    bitwig.enable = true;
  };

  xdg = {
    enable = true;

    cacheHome = /mnt/games/cache/ayes;
    desktopEntries = {
      noitaEntangledWorlds = {
        type = "Application";
        genericName = "noita-proxy";
        name = "Noita Entangled Worlds";
        icon = ../../../../assets/images/noita-proxy.png;
        exec = "sh -c \"steam-run /mnt/games/noita_entangled_worlds/noita_proxy.x86_64\"";
      };
    };

    /*configFile = {
      "baloofilerc" = {
        enable = true;

        text = ''
          [General]
          dbVersion=2
          exclude filters version=9
          exclude folders[$e]=/recovery/
          index hidden folders=true
          only basic indexing=true
        '';
      };
    };*/
  };

  gtk.gtk2.enable = false;
}
