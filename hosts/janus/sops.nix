{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    # Host-specific secrets file (uncomment when secrets/janus.yaml exists)
    # defaultSopsFile = ../../secrets/janus.yaml;

    secrets = {
      "matrix/registration_secret" = {
        owner = "ayes";
      };
    };
  };
}
