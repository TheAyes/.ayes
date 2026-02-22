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

      "livekit/key" = {};
      "livekit/secret" = {};
      "matrix/turn_shared_secret" = {
        owner = "matrix-synapse";
        group = "matrix-synapse";
      };
      "coturn/static_auth_secret" = {
        owner = "turnserver";
        group = "turnserver";
      };
    };

    templates."livekit-keyfile".content = ''
      ${config.sops.placeholder."livekit/key"}: ${config.sops.placeholder."livekit/secret"}
    '';
  };
}
