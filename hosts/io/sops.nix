{ config, ... }: {
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/ayes/.config/sops/age/keys.txt";
    secrets = {
      "cloudflare/aethyria-tunnel-token" = { owner = config.users.users.ayes.name; };
      "cloudflare/cert" = { owner = config.users.users.ayes.name; };
      "cloudflare/api-token" = { owner = config.users.users.ayes.name; };

      "minecraft-server/rcon-password" = { owner = config.users.users.ayes.name; };
    };
  };
}
