{ pkgs
, lib
, hostname
, ...
}:
{
  networking.hostName = hostname;

  imports = [
    ../../profiles/nixos/locales/german.nix
    ../../profiles/nixos/services/ssh-server.nix
    ../../profiles/nixos/security/sudo-nopassword.nix
    ../../profiles/nixos/networking/firewall.nix
    ../../profiles/nixos/networking/nameservers.nix
    ../../profiles/nixos/networking/dhcp.nix

    ./filesystem.nix
    ./sops.nix
    ./reverse-proxy.nix
    ./matrix-server.nix
    ./teamspeak-server.nix
    ./livekit.nix
    #./mail-server.nix
    ./coturn-server.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  nix.settings = {
    trusted-users = [ "root" "@wheel" ];
    trusted-public-keys = [ "io:Zu/umjucw6vgqfr8Y1RA039dxtjNzT23HyIz6BoL9Bg=" "leda:I2NgSQksndXEYvjCiVShBM9/zNPQN7k8u8za0R0QJTM=" ];
  };

  nixpkgs.config = {
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };


  users.users = {
    root.hashedPassword = "!"; # Disable root login

    ayes = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGLOpO2V5KWikN+N3eZm3JaWcIABxjpOiMvOdFOk/ijA ayes@io"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyhtn5mvYllUOMfg4MmCNWSl1So1WQNegcWk095YccW ayes@leda"
      ];
    };
  };

  programs = {
    fish.enable = true;
  };
}
