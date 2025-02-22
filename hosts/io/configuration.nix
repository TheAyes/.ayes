{ hostname, pkgs, config, ... }: {
  imports = [
    ./hardware-configuration.nix

    # System Modules
    ../../presets/nixos/boot/systemd-boot.nix
    ../../presets/nixos/desktopManagers/kde.nix
    ../../presets/nixos/audio/pipewire.nix
    ../../presets/nixos/networking/default.nix

    ../../presets/nixos/locales/german.nix

    # Program Modules
    ../../presets/nixos/programs/steam.nix
  ];

  ##################################
  ## Programs
  ##################################
  programs = {
    partition-manager.enable = true;
    firefox.enable = true;
  };

  ##################################
  ## Services
  ##################################
  services = { };

  ##################################
  ## Networking
  ##################################
  networking = { };

  ##################################
  ## Ssecurity
  ##################################
  security = {
    sudo.wheelNeedsPassword = false;
  };

  ##################################
  ## Boot
  ##################################
  boot = { };
}
