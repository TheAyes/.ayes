{pkgs, ...}: {
  imports = [
    ./hardware.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    kernelModules = [
      "amdgpu"
    ];

    kernelParams = [
      "video=DP-1:1920x1080@60"
      "video=DP-2:1920x1080@60"
      "video=HDMI-A-1:1920x1080@60"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd.dbus.enable = true;
  };
}
