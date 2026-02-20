{
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
      device = "/dev/sdb";
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
