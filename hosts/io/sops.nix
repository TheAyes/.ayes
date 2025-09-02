{
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/ayes/.config/sops/age/keys.txt";
    secrets = {
      cloudflare-tunnel-token = { };
    };
  };
}
