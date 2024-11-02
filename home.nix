{ config, pkgs, inputs, lib, nixpkgs-alternate, ... }: {
  imports = [
    ./config/vesktop.nix
    ./config/hypr/hyprland.base.nix
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
      obs-studio
      xarchiver

      ##hyprstuff
      inputs.hyprsome.packages.${pkgs.stdenv.hostPlatform.system}.default
      hyprshot

      ## Media
      bitwig-studio
      haruna
      obsidian
      gpu-screen-recorder-gtk
      yabridge
      yabridgectl

      ## configuration Utils
      solaar
      font-manager

      ## Community
      vesktop

      ## Gaming
      xivlauncher
      prismlauncher
      heroic
      lutris

      ## Dev Stuff
      jetbrains.idea-ultimate
      jetbrains.webstorm
      nodejs
      bun
      sassc

      graalvm-ce
    ];

    file = {
      "${config.xdg.configHome}/micro/colorschemes" = {
        source = ./config/micro/colorschemes;
        recursive = true;
      };

      "${config.xdg.configHome}/btop" = {
        source = ./config/btop;
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


  /*gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue-Dark";
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      };
    };
  };*/

  /*qt = {
    enable = true;
    style = {
      name = "kvantum";
    };
    platformTheme = "qtct";
  };*/

  stylix = {
    enable = true;
    targets = {
      firefox = {
        profileNames = [ "default" ];
      };
    };
  };

  programs = {
    ags = {
      enable = true;
      configDir = ./config/ags;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;

      config = { };
    };

    kitty = {
      enable = true;

      settings = {
        shell_integration = true;
      };

      extraConfig = import ./config/kittyExtra.nix;
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      package = pkgs.eza;
      git = true;
      icons = "auto";
    };

    librewolf = {
      enable = false;
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
      };

      functions = {
        rebuild = "/home/ayes/.nixos/rebuild.sh $argv";
        test-rebuild = "/home/ayes/.nixos/test.sh $argv";
        upgrade = "/home/ayes/.nixos/upgrade.sh $argv";

        fish_prompt = ''
          					#Save the return status of the previous command
          					set -l last_pipestatus $pipestatus
          					set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

          					if functions -q fish_is_root_user; and fish_is_root_user
          						printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
          																		 and set_color $fish_color_cwd_root
          																		 or set_color $fish_color_cwd) \
          							(prompt_pwd) (set_color normal)
          					else
          						set -l status_color (set_color $fish_color_status)
          						set -l statusb_color (set_color --bold $fish_color_status)
          						set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

          						printf '[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) \
          							$USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string \
          							(set_color normal)
          					end
          				'';
      };

      shellInitLast = ''
        	clear
      '';
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

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "pcmanfm.desktop" ];
        "application/pdf" = [ "firefox.desktop" ];

        ## Archives ##
        "application/vnd.rar" = [ "xarchiver.desktop" ];
        "application/zip" = [ "xarchiver.desktop" ];
        "application/x-7z-compressed" = [ "xarchiver.desktop" ];
        "application/gzip" = [ "xarchiver.desktop" ];
        "application/x-tar" = [ "xarchiver.desktop" ];

        ## Videos ##
        "application/mp4" = [ "haruna.desktop" ];

        ## Music ##
        "application/mp3" = [ "haruna.desktop" ];
        "application/wav" = [ "haruna.desktop" ];
      };
    };
  };
}
