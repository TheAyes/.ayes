{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    # Host-specific secrets file
    defaultSopsFile = ../../secrets/io.yaml;

    secrets = {
      "github/access-token" = {
        owner = config.users.users.ayes.name;
      };

      "minecraft-server/rcon-password" = {
        owner = config.users.users.ayes.name;
      };
    };
  };
}
