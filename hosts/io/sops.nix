{ config, ... }:

{
  imports = [
    ../../profiles/nixos/services/sops.nix
  ];

  sops = {
    # Host-specific secrets file
    defaultSopsFile = ../../secrets/io.yaml;

    secrets = {
      "cloudflare/aethyria-tunnel-token" = {
        owner = config.users.users.ayes.name;
      };
      "cloudflare/cert" = {
        owner = config.users.users.ayes.name;
      };
      "cloudflare/api-token" = {
        owner = config.users.users.ayes.name;
      };

      "github/access-token" = {
        owner = config.users.users.ayes.name;
      };

      "minecraft-server/rcon-password" = {
        owner = config.users.users.ayes.name;
      };
    };
  };
}
