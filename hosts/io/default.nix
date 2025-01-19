{
  pkgs,
  host,
  ...
}: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./language.nix
    ./boot.nix
    ./security.nix

    # Modules
    ../../modules/hyprland.nix
    ../../modules/steam.nix
  ];
}
