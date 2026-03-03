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
      "matrix/turn_shared_secret" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
      };
      "coturn/static_auth_secret" = {
        owner = "turnserver";
        group = "turnserver";
      };
    };
  };
}
