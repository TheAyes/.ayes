{ hostname, pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix

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
    config.rocmSupport = true;
  };

  ##################################
  ## Environment
  ##################################
  environment = {
    systemPackages = with pkgs; [
      qpwgraph

      wineWowPackages.staging
      winetricks
    ];
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
    partition-manager.enable = true;
    firefox.enable = false;
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
    foot = {
      enable = true;
      theme = "catppuccin-mocha";
      settings = {
        main = {
         font = "FreeMono:size=11";
        };

        scrollback = {
         lines = 100000;
        };

        colors = {
          #alpha = 0.8;
        };
      };
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
  };

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
