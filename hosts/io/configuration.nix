{ hostname, pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix

    # System Modules
    ../../presets/nixos/boot/systemd-boot.nix
    ../../presets/nixos/desktopManagers/kde.nix
    ../../presets/nixos/audio/pipewire.nix
    ../../presets/nixos/networking/default.nix
    ../../presets/nixos/security
    ../../presets/nixos/hardware/bluetooth.nix

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
    config = {
      rocmSupport = true;
    };
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
  };

  ##################################
  ## Services
  ##################################
  services = {
    udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
    '';

    ollama = {
      enable = true;
      rocmOverrideGfx = "11.0.1";
      acceleration = "rocm";
      # Optional: load models on startup
      loadModels = [ ];
    };

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
  ## Ssecurity
  ##################################
  security = {
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;
  };

  ##################################
  ## Boot
  ##################################
  boot = {
    #kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = [
      "amdgpu"
    ];

    kernelPatches = [
      {
        name = "amdgpu-ignore-ctx-privileges";
        patch = pkgs.fetchpatch {
          name = "cap_sys_nice_begone.patch";
          url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
          hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
        };
      }
    ];
  };

  ## Misc
  musnix = {
    enable = true;

    kernel = {
      realtime = true;
      packages = pkgs.linuxPackages_latest_rt;
    };

    rtirq.enable = true;
  };
}
