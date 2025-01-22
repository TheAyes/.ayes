{...}: {
  imports = [
    ./hardware.nix
    #./networking.nix
    #./language.nix
    ./boot.nix
    #./security.nix
    #./nix.nix

    # Modules
    #../../modules/hyprland.nix
    #../../modules/steam.nix
  ];

  /*
    user-manager = {
    ayes = {
      groups = ["wheel" "networkmanager"];
    };
  };
  */

  users.users = {
    ayes = {
      isNormalUser = true;
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  system.stateVersion = "23.11";
}
