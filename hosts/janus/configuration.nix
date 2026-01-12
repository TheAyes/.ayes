{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../presets/nixos/locales/german.nix
  ];

  environment.systemPackages = with pkgs; [
    micro
    git
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "ext4";
    };

    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    "ext4"
  ];

  users.users = {
    root.hashedPassword = "!"; # Disable root login
    username = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyZyJ2UKkA2jeZgwd8x3Y17EF7w15MuwZRttLlPdar9DfLHbo1b5buk9SMZnQBsr33loO+cDFMhAu2F1r2AzwdxPNb8wiNNbwsQj7eUxAJv9UUmlFrG0d1RPkL16h17wJePtSUvuT7uVoKB049WQVF7wcJ4A+3ugW4ivQaU+lKLlpEG35maNPhW00yd+pU5UFdHLb/ZbuuOBouAEfVxYGetC0UAAxV96zWUy6Vh74iZbEaHxYmjSb54eTag9/ldVScIVA64oc1zrHsfqqDwJjJQ+o9AHlLrWMf3n/uCtbkNUqcMbu1v3r+xeCqAnHc5WfNPz3YaHkYZVErYLO35kkJWwY+t/gJxyxU3rZfiVTs+7v0NZ5wub4nAnAK1xb03qByVb2QjM0yn0WUvA6XwrqwtKPin8rMnOwg08P8oE4XkRcTVrkHeA4L1mu+59jXYE5sHpMRrwTiakcoxIyXrDknLYEse6JG85AiwCKf5IJ8ftbTAEMx23aTWZHrctanJj8= ayes@io"
      ];
    };
  };
  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
