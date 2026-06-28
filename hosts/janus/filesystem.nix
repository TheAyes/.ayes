{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };

    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  boot = {
    loader.grub = {
      enable = true;
      # Boot disk is the QEMU HARDDISK (msdos, holds /boot + /), NOT the GPT
      # Hetzner cloud volume that now enumerates as /dev/sda. Pin by stable
      # by-id path so a device-name swap can't point GRUB at the wrong disk.
      device = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_109601625";
    };

    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "sd_mod"
      "sr_mod"
      "ext4"
    ];
  };
}
