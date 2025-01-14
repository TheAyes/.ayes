{ config, pkgs, inputs, lib, ... }: {
  imports = [
    ../config/vesktop.nix
    ../config/kittyExtra.nix
    ../config/hypr/hyprland.base.nix
    ../config/kde.nix
    inputs.ags.homeManagerModules.default
  ];

  home = {
    username = "ayes";
    homeDirectory = lib.mkForce "/home/ayes";
    stateVersion = "23.11";

    packages = with pkgs; [
      ## Systm
      btop
      micro
      dolphin
      # pcmanfm
      ark
      kdePackages.kio
      kdePackages.kio-admin
      kdePackages.kio-extras
      kdePackages.kio-extras-kf5
      kdePackages.wayland-protocols

      ##hyprstuff
      inputs.hyprsome.packages.${pkgs.stdenv.hostPlatform.system}.default
      #hyprshot

      ## Media
      bitwig-studio
      haruna
      obsidian
      gpu-screen-recorder-gtk

      (yabridge.override { wine = wineWowPackages.waylandFull; })
      (yabridgectl.override { wine = wineWowPackages.waylandFull; })

      kdePackages.gwenview
      kdePackages.okular
      kdePackages.kolourpaint
      kdePackages.kcalc

      dotool

      ## configuration Utils
      solaar
      font-manager
      libratbag
      piper

      ## Community
      #vesktop
      equibop

      ## Gaming
      xivlauncher
      prismlauncher
      heroic
      lutris

      ## Dev Stuff
      jetbrains.idea-ultimate
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains-toolbox

      godot_4
      gdtoolkit_4

      nodejs
      bun
      sassc
      rustup

      graalvm-ce
      vdhcoapp
    ];

    file = {
      "${config.xdg.configHome}/micro" = {
        source = ../config/micro;
        recursive = true;
      };

      "${config.xdg.configHome}/btop" = {
        source = ../config/btop;
        recursive = true;
      };

      "${config.xdg.configHome}/equibop" = {
        source = ../config/equibop;
        recursive = true;
      };
    };

    /*pointerCursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 24;

      gtk.enable = true;
      x11.enable = true;
    };*/
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = [ "NotoSerif Nerd Font" ];
      sansSerif = [ "FiraMono Nerd Font Propo" ];
      monospace = [ "FiraCode Nerd Font Propo" ];
    };
  };


  gtk = {
    enable = true;
    /*theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark";
    };*/

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
  };

  qt = {
    enable = true;
    /*style.name = "breeze";*/
    platformTheme.name = "qt5ct";
    style = {
      name = "kvantum";
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;

    targets = {
      firefox.enable = true;

      gtk.enable = true;
      gnome.enable = true;
      hyprland.enable = true;
      hyprpaper.enable = true;
      kde.enable = true;
      kitty.enable = false;
      vesktop.enable = false;
      wofi.enable = true;
    };
  };

  programs = {
    ags = {
      enable = true;
      configDir = ../config/ags;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };

    kitty = {
      enable = true;

      shellIntegration.enableFishIntegration = true;

      #extraConfig = import ./config/kittyExtra.nix;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      #package = pkgs.eza;
      git = true;
      icons = "auto";
    };

    librewolf = {
      enable = false;

      settings = { };
    };



    firefox = {
      enable = true;
      policies = {
        PasswordManagerEnabled = false;
        PopupBlocking = true;
        OfferToSaveLogins = false;
        HardwareAcceleration = true;

        ExtensionUpdate = true;
        ExtensionSettings =
          let
            extensionUrl = x: "https://addons.mozilla.org/firefox/downloads/latest/${x}/latest.xpi";
          in
          {
            "uBlock0@raymondhill.net" = {
              installation_mode = "force_installed";
              install_url = extensionUrl "ublock-origin";
            };

            "addon@darkreader.org" = {
              installation_mode = "force_installed";
              install_url = extensionUrl "darkreader";
            };

            "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
              installation_mode = "force_installed";
              install_url = extensionUrl "proton-pass";
            };

            "FirefoxColor@mozilla.com" = {
              installation_mode = "force_installed";
              install_url = extensionUrl "firefox-color";
            };
          };
      };
    };

    micro = {
      enable = true;
      settings = {
        autosu = true;
        mkparents = true;
        colorscheme = "rose-pine";
      };
    };

    wofi = {
      enable = true;
      package = pkgs.wofi;
      settings = {
        prompt = "Search";
        matching = "contains";
        insensitive = true;
      };
    };

    fish = {
      enable = true;
      shellAliases = {
        l = "ls -alh --color=auto";
        ll = "ls -l --color=auto";
        ls = "ls --color=auto";
        rebuild = "~/.nixos/rebuild.sh";
        upgrade = "~/.nixos/upgrade.sh";
        test-rebuild = "~/.nixos/test.sh";
        logout = "hyprctl dispatch exit";
      };

      functions = {
        rebuild = "/home/ayes/.nixos/rebuild.sh $argv";
        test-rebuild = "/home/ayes/.nixos/test.sh $argv";
        upgrade = "/home/ayes/.nixos/upgrade.sh $argv";

        #fish_prompt = '' '';
      };
    };

    bash = {
      enable = true;
      initExtra = ''
        				if [[
        					$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" &&
        					-z ''${BASH_EXECUTION_STRING}
        				]] then
        					shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        					exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        				fi
        			'';
    };

    git = {
      enable = true;
      userName = "Ayes";
      userEmail = "github.com.faculty419@passmail.net";
      lfs.enable = true;
      diff-so-fancy.enable = true;

      extraConfig = {
        user = {
          name = "Ayes";
          email = "github.com.faculty419@passmail.net";
        };

        credential = {
          credentialStore = "secretservice";
        };
      };
    };

    hyprlock = {
      enable = false;
      settings = {
        general = {
          disable_loading_bar = false;
          grace = 0;
          hide_cursor = false;
          no_fade_in = false;
        };

        background = [
          {
            color = "rgba(25, 20, 20, 1.0)";

            blur_passes = 3;
            blur_size = 12;
            noise = 0.0117;
          }
        ];

        input-field = [
          {
            size = "300, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 3;
            placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
            shadow_passes = 2;
          }
        ];
      };

    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-replay-source
        obs-pipewire-audio-capture
        advanced-scene-switcher
      ];
    };
  };

  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [
          "/home/ayes/.nixos/config/hypr/wallpapers/dark_love_wallpaper.jpg"
          "/home/ayes/.nixos/config/hypr/wallpapers/dark_anime_wallpaper.jpg"
          "/home/ayes/.nixos/config/hypr/wallpapers/black-rock-shooter-43606-1920x1080.jpg"
        ];

        wallpaper = [
          "DP-1, /home/ayes/.nixos/config/hypr/wallpapers/dark_love_wallpaper.jpg"
          "DP-2, /home/ayes/.nixos/config/hypr/wallpapers/dark_anime_wallpaper.jpg"
          "HDMI-A-1, /home/ayes/.nixos/config/hypr/wallpapers/black-rock-shooter-43606-1920x1080.jpg"
        ];
      };
    };

    cliphist = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };

    hypridle = {
      enable = true;
      settings = {
        general = { };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
        ];
      };
    };

    arrpc.enable = true;
  };

  wayland = {
    windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };

      xwayland = {
        enable = true;
      };
    };
  };

  xdg = {
    desktopEntries = {
      xivlauncher = {
        name = "XIVLauncher";
        exec = ''sh -c "XIVLauncher.Core & NIXPKGS_ALLOW_UNFREE=1 nix-shell -p fflogs --run fflogs"'';
        genericName = "Custom launcher for FFXIV";
      };
    };

    mime = {
      enable = true;
    };

    mimeApps =
      let
        applications = {
          "inode/directory" = [ "dolphin.desktop" ];
          "application/pdf" = [ "okular.desktop" "firefox.desktop" ];

          ## Text ##
          "text/plain" = [ "micro.desktop" ];
          "text/typescript" = [ "micro.desktop" ];

          ## Pictures ##
          "application/png" = [ "gwenview.desktop" "firefox.desktop" ];
          "application/jpeg" = [ "gwenview.desktop" "firefox.desktop" ];

          ## Archives ##
          "application/zip" = [ "ark.desktop" ]; # or your preferred archive manager
          "application/x-zip" = [ "ark.desktop" ];
          "application/x-zip-compressed" = [ "ark.desktop" ];
          "application/x-rar" = [ "ark.desktop" ];
          "application/x-rar-compressed" = [ "ark.desktop" ];
          "application/x-7z-compressed" = [ "ark.desktop" ];
          "application/x-tar" = [ "ark.desktop" ];
          "application/x-bzip" = [ "ark.desktop" ];
          "application/x-bzip2" = [ "ark.desktop" ];
          "application/x-gzip" = [ "ark.desktop" ];
          "application/gzip" = [ "ark.desktop" ];
          "application/x-xz" = [ "ark.desktop" ];
          "application/x-compress" = [ "ark.desktop" ];
          "application/x-compressed" = [ "ark.desktop" ];
          "application/vnd.rar" = [ "ark.desktop" ];

          ## Videos ##
          "application/mp4" = [ "haruna.desktop" "firefox.desktop" ];

          ## Music ##
          "application/mp3" = [ "haruna.desktop" "firefox.desktop" ];
          "application/wav" = [ "haruna.desktop" "firefox.desktop" ];

          ## System ##
          "application/x-desktop" = [ "kitty.desktop" ];
        };
      in
      {
        enable = true;

        associations.added = applications;
        defaultApplications = applications;
      };
  };
}
