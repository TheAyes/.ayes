{
  inputs,
  config,
  pkgs,
  users,
  ...
}:
#
# The absolute minimum system config required for my nix setup
# Shouldn't be required to use flakes to run this, nor any secrets
# Should be compatible with ALL hosts, including golden images
#
{
  # ==============================
  # General System Config
  # ==============================
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    git
  ];

  users = {
    mutableUsers = true;
  };

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };
  };

  # ==============================

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # If we change this things will be sad
  system.stateVersion = "23.11";
}
