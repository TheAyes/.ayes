{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../presets/nixos/locales/german.nix
    ../../presets/nixos/boot/systemd-boot.nix
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
}
