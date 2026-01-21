{
  pkgs,
  inputs,
  ...
}:
{
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
      #keepassxc
      sops
      #cloudflared
      protonvpn-gui

      qpwgraph

      ffmpeg
      libopus
      #vital

      wineWowPackages.staging
      winetricks
      bottles

      dnsmasq
      quickemu
      spice
      spice-gtk

      rocmPackages.rocm-device-libs
      rocmPackages.hsakmt
      rocmPackages.amdsmi

      vulkan-tools
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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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

    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
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
    # https://wiki.nixos.org/wiki/Linux_kernel
    kernelPackages = pkgs.linuxPackages_zen;
  };
}
