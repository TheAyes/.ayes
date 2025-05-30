# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/77c30c8c-2b73-4596-ac6e-44ba4cf606a5";
      fsType = "ext4";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/a1b38f00-6ecc-44db-8f2f-6e13d880eb19";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4213-C231";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/215985a5-1a1f-441e-9399-c1fd1ecfc761";
      fsType = "ext4";
    };

  fileSystems."/mnt/games" =
    { device = "/dev/disk/by-uuid/8da931bf-76ed-40b6-a030-70647e755c1a";
      fsType = "ext4";
    };

  fileSystems."/mnt/projects" =
    { device = "/dev/disk/by-uuid/df4ccd26-7eee-4410-a0e4-05fd70f5d633";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/b606395b-1c6c-4289-82c8-11391b40e501"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
