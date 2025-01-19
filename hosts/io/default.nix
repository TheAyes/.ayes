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
  ];
}
