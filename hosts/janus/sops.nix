{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    # Host-specific secrets file (uncomment when secrets/janus.yaml exists)
    # defaultSopsFile = ../../secrets/janus.yaml;

    secrets = {
      # Add janus-specific secrets here
      # "example/secret" = {
      #   owner = "root";
      # };
    };
  };
}
