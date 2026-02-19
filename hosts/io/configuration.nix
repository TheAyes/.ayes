{ pkgs
, inputs
, ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./fail2ban.nix
    ./sops.nix
    ./minecraft-servers.nix

    # System Profiles
    ../../profiles/nixos/boot/systemd-boot.nix
    ../../profiles/nixos/desktopManagers/kde.nix
    ../../profiles/nixos/audio/pipewire.nix
    ../../profiles/nixos/networking/default.nix
    ../../profiles/nixos/security

    ../../profiles/nixos/hardware/amdgpu.nix
    ../../profiles/nixos/hardware/bluetooth.nix
    ../../profiles/nixos/hardware/logitech.nix

    ../../profiles/nixos/locales/german.nix

    # Program Profiles
    ../../profiles/nixos/programs/steam.nix
    #../../profiles/nixos/programs/envision.nix
    ../../profiles/nixos/programs/lact.nix
    ../../profiles/nixos/programs/obs.nix
    ../../profiles/nixos/programs/nix-ld.nix

    # Gaming Profiles
    ../../profiles/nixos/gaming/wine.nix

    # Virtualization Profiles
    ../../profiles/nixos/virtualization/docker.nix
    ../../profiles/nixos/virtualization/libvirt.nix

    # Service Profiles
    ../../profiles/nixos/services/ollama-rocm.nix
  ];

  fileSystems = {
    "/home/ayes/.xlcore" = {
      device = "/etc/nixos/users/ayes/external/xlcore";
      depends = [
        "/"
        "/home"
      ];
      fsType = "none";
      options = [ "bind" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/a1b38f00-6ecc-44db-8f2f-6e13d880eb19";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/215985a5-1a1f-441e-9399-c1fd1ecfc761";
      fsType = "ext4";
      depends = [
        "/"
        "/nix"
      ];
    };

    "/mnt/games" = {
      device = "/dev/disk/by-uuid/8da931bf-76ed-40b6-a030-70647e755c1a";
      fsType = "ext4";
      depends = [
        "/"
        "/nix"
      ];
    };

    "/mnt/projects" = {
      device = "/dev/disk/by-uuid/df4ccd26-7eee-4410-a0e4-05fd70f5d633";
      fsType = "ext4";
      depends = [
        "/"
        "/nix"
      ];
    };
  };

  systemd.user.services.clear-cache = {
    description = "Clear user cache";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'rm -rf $XDG_CACHE_HOME/*'";
    };
  };

  systemd.user.timers.clear-cache = {
    description = "Clear cache weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  ##################################
  ## Nix
  ##################################
  nix.settings = {
    secret-key-files = [ "/etc/nix/private-key" ];
  };

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
      sops
      protonvpn-gui

      qpwgraph

      ffmpeg
      libopus

      dnsmasq

      rocmPackages.rocm-device-libs
      rocmPackages.hsakmt
      rocmPackages.amdsmi

      vulkan-tools
    ];
  };

  # Additional nix-ld libraries (profile provides base)
  programs.nix-ld.libraries = with pkgs; [
    portaudio
    rocmPackages.llvm.llvm
  ];

  ##################################
  ## Programs
  ##################################
  programs = {
    hyprland = {
      enable = false;
    };
    partition-manager.enable = true;
    firefox.enable = false;
    gamemode.enable = true;
    fish.enable = true;
    ssh.startAgent = true;

    kdeconnect.enable = true;
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

    mautrix-discord = {
      enable = false; # Maybe in the future once I get a home-server
    };

    udev = {
      enable = true;
      extraRules = ''
        ATTRS{name}=="Sony Computer Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
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
    # https://wiki.nixos.org/wiki/Linux_kernel
    kernelPackages = pkgs.linuxPackages_zen;
  };
}
