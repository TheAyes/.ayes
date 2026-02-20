{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    defaultSopsFile = ../../secrets/janus.yaml;

    secrets = {
      "matrix/synapse_secrets" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
      };
    };
  };
}
