{ hostname
, pkgs
, config
, lib
, inputs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./fail2ban.nix

    # System Modules
    ../../presets/nixos/boot/systemd-boot.nix
    ../../presets/nixos/desktopManagers/kde.nix
    ../../presets/nixos/audio/pipewire.nix
    ../../presets/nixos/networking/default.nix
    ../../presets/nixos/security

    ../../presets/nixos/hardware/amdgpu.nix
    ../../presets/nixos/hardware/bluetooth.nix
    ../../presets/nixos/hardware/logitech.nix

    ../../presets/nixos/locales/german.nix

    # Program Modules
    ../../presets/nixos/programs/steam.nix
    #../../presets/nixos/programs/envision.nix
    ../../presets/nixos/programs/lact.nix
  ];

  ##################################
  ## Nix
  ##################################
  nix = { };

  nixpkgs = {
    config = {
      rocmSupport = true;
    };
    overlays = [ inputs.nix-minecraft.overlay ];
  };

  ##################################
  ## Environment
  ##################################
  environment = {
    systemPackages = with pkgs; [
      keepassxc
      sops
      #cloudflared

      qpwgraph

      ffmpeg
      libopus
      #vital

      wineWowPackages.staging
      winetricks
      bottles

      rocmPackages.rocm-device-libs
      rocmPackages.hsakmt
      rocmPackages.amdsmi
    ];

    variables =
      let
        makePluginPath = format:
          (lib.strings.makeSearchPath format [
            "$HOME/.nix-profile/lib"
            "/run/current-system/sw/lib"
            "/etc/profiles/per-user/$USER/lib"
          ])
          + ":$HOME/.${format}";
      in
      {
        DSSI_PATH = makePluginPath "dssi";
        LADSPA_PATH = makePluginPath "ladspa";
        LV2_PATH = makePluginPath "lv2";
        LXVST_PATH = makePluginPath "lxvst";
        VST_PATH = makePluginPath "vst";
        VST3_PATH = makePluginPath "vst3";
      };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      portaudio
      stdenv.cc.cc.lib
      rocmPackages.llvm.llvm
    ];
  };

  ##################################
  ## Groups
  ##################################
  users.groups.gaming = {
    members = [ "ayes" "janny" ];
  };

  ##################################
  ## Programs
  ##################################
  programs = {
    hyprland = { enable = true; };
    partition-manager.enable = true;
    firefox.enable = false;
    gamemode.enable = true;
    fish.enable = true;

    kdeconnect.enable = true;
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-replay-source
        advanced-scene-switcher
        obs-pipewire-audio-capture
      ];
    };
  };

  ##################################
  ## Services
  ##################################
  services = {
    solaar = {
      enable = true; # Enable the service
      window = "hide"; # Show the window on startup (show, *hide*, only [window only])
      batteryIcons = "regular"; # Which battery icons to use (*regular*, symbolic, solaar)
      extraArgs = ""; # Extra arguments to pass to solaar on startup
    };

    ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "gfx1101";
    };

    udev = {
      enable = true;
      extraRules = ''
        ATTRS{name}=="Sony Computer Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };

    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers.prominence =
        let
          allowedRam = "32G";
        in
        {
          enable = true;
          autoStart = true;
          openFirewall = true;
          package = pkgs.fabricServers.fabric-1_20_1;
          jvmOpts = "-Xmx${allowedRam} -Xms${allowedRam}";
          serverProperties = {
            gamemode = 3;
            force-gamemode = true;
            difficulty = 3;
            max-players = 10;
            white-list = true;
            enforce-whitelist = true;
            #level-seed = "-7827161134340464580";
            pvp = false;
            sync-chunk-write = false;
            simulation-distance = 8;
            view-distance = 12;
          };

          whitelist = {
            Ayes_For_Real = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
            Slayandra = "548c4941-a799-40a0-b149-4296084ab876";
            Bestiary = "3585a188-dd90-4322-8e89-3bb457648e82";
            Yuzumi25 = "8f371ca9-3095-4a7d-a641-9592e5355ba4";
            Ebilknibel = "89055e10-10cc-4cf0-a872-b5e713a786ba";
            Tekklar334 = "cba06ef3-102b-43e9-962d-62ef49fc1ff3";
            moonshiiine = "a09fedac-4b1c-485d-86b5-436a087b110d";
          };

          symlinks = {
            "ops.json" = {
              value = [
                {
                  name = "Ayes_For_Real";
                  uuid = "9de723f7-dc47-4f22-bc46-bdf912e99f80";
                  level = 99;
                }
              ];
            };
          };
        };
    };

    cloudflared = {
      enable = true;
      tunnels = {
        # "Aethyria-Service-Tunnel" = {
        #credentialsFile = "${config.sops.secrets.cloudflared-creds.path}";
        # };
      };
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts = {
      serif = {
        package = pkgs.caladea;
        name = "Caladea-Regular";
      };

      sansSerif = {
        package = pkgs.encode-sans;
        name = "EncodeSans-Regular";
      };

      monospace = {
        package = pkgs.cascadia-code;
        name = "CascadiaCodeNF";
      };

      emoji = {
        package = pkgs.serenityos-emoji-font;
        name = "SerenityOS Emoji";
      };
    };

    autoEnable = false;
    targets = {
      gtk.enable = true;
      qt.enable = true;

      grub.enable = false;
    };
  };

  virtualisation.docker.enable = true;

  ##################################
  ## Networking
  ##################################
  networking = { };

  ##################################
  ## Security
  ##################################
  security = { };

  ##################################
  ## Boot
  ##################################
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
  };
}
