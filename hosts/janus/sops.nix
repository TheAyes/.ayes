{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    defaultSopsFile = ../../secrets/janus.yaml;

    secrets = {
      "matrix/registration_secret" = {
        owner = "ayes";
      };
    };
  };
}
