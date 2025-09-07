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
    ./sops.nix
    ./minecraft-servers.nix

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

    ddclient = {
      enable = true;
      quiet = true;

      ssl = true;
      protocol = "cloudflare";

      passwordFile = "${config.sops.secrets."cloudflare/api-token".path}";
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
