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
    ../../presets/nixos/programs/envision.nix
  ];

  ##################################
  ## Nix
  ##################################
  nix = { };

  nixpkgs = {
    config.rocmSupport = true;
  };

  ##################################
  ## Filesystems
  ##################################
  fileSystems = {
    "/games" = {
      enable = true;
      neededForBoot = false;
      device = "/dev/disk/by-uuid/8da931bf-76ed-40b6-a030-70647e755c1a";
      fsType = "ext4";
    };

    "/home/ayes/projects" = {
      enable = true;
      neededForBoot = false;
      device = "/dev/disk/by-uuid/0aac6061-404b-4749-b9f6-ff0958a33c74";
      fsType = "ext4";
    };
  };

  ##################################
  ## Environment
  ##################################
  environment = {
    systemPackages = with pkgs; [
      qpwgraph
      easyeffects

      wineWow64Packages.stagingFull
      winetricks
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
    firefox.enable = true;
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
