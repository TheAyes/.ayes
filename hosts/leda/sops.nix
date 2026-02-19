{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    # Host-specific secrets file (create secrets/leda.yaml when needed)
    # defaultSopsFile = ../../secrets/leda.yaml;

    secrets = {
      # Add leda-specific secrets here
      # "example/secret" = {
      #   owner = "root";
      # };
    };
  };
}
