{ pkgs
, ...
}:
{
  imports = [
    ./filesystem.nix
    ./sops.nix
    ../../profiles/nixos/locales/german.nix
    ../../profiles/nixos/services/ssh-server.nix
    ../../profiles/nixos/security/sudo-nopassword.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  nix.settings = {
    trusted-users = [ "root" "@wheel" ];
    trusted-public-keys = [ "io:Zu/umjucw6vgqfr8Y1RA039dxtjNzT23HyIz6BoL9Bg=" "leda:I2NgSQksndXEYvjCiVShBM9/zNPQN7k8u8za0R0QJTM=" ];
  };

  users.users = {
    root.hashedPassword = "!"; # Disable root login

    ayes = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyZyJ2UKkA2jeZgwd8x3Y17EF7w15MuwZRttLlPdar9DfLHbo1b5buk9SMZnQBsr33loO+cDFMhAu2F1r2AzwdxPNb8wiNNbwsQj7eUxAJv9UUmlFrG0d1RPkL16h17wJePtSUvuT7uVoKB049WQVF7wcJ4A+3ugW4ivQaU+lKLlpEG35maNPhW00yd+pU5UFdHLb/ZbuuOBouAEfVxYGetC0UAAxV96zWUy6Vh74iZbEaHxYmjSb54eTag9/ldVScIVA64oc1zrHsfqqDwJjJQ+o9AHlLrWMf3n/uCtbkNUqcMbu1v3r+xeCqAnHc5WfNPz3YaHkYZVErYLO35kkJWwY+t/gJxyxU3rZfiVTs+7v0NZ5wub4nAnAK1xb03qByVb2QjM0yn0WUvA6XwrqwtKPin8rMnOwg08P8oE4XkRcTVrkHeA4L1mu+59jXYE5sHpMRrwTiakcoxIyXrDknLYEse6JG85AiwCKf5IJ8ftbTAEMx23aTWZHrctanJj8= ayes@io"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyhtn5mvYllUOMfg4MmCNWSl1So1WQNegcWk095YccW ayes@leda"
      ];
    };
  };

  programs = {
    fish.enable = true;
  };

  services = {
    matrix-synapse = {
      enable = true;
    };
  };
}
