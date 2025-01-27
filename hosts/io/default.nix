{ ... }: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./language.nix
    ./boot.nix
    ./security.nix
    ./nix.nix

    ../../configs/steam.nix
    ../../configs/hyprland.nix
  ];

}
