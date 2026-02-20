{ config, ... }:
{
  services.matrix-synapse = {
    enable = true;
    settings = {
      server_name = "convene.chat";
      public_baseurl = "https://matrix.convene.chat";


      listeners = [
        {
          port = 8008;
          bind_addresses = [ "127.0.0.1" ];
          type = "http";
          tls = false;
          x_forwarded = true;
          resources = [
            {
              names = [ "client" "federation" ];
              compress = true;
            }
          ];
        }
      ];
    };

    extraConfigFiles = [ config.sops.secrets."matrix/synapse_secrets".path ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "matrix-synapse" ];
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
    ];
  };
}
