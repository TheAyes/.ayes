{ config, pkgs, ... }:
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

      turn_uris = [
        "turn:turn.convene.chat:3478?transport=udp"
        "turn:turn.convene.chat:3478?transport=tcp"
      ];
      turn_user_lifetime = "1h";
      turn_allow_guests = false;
    };

    extraConfigFiles = [
      config.sops.secrets."matrix/synapse_secrets".path
      config.sops.secrets."matrix/turn_shared_secret".path
    ];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "matrix-synapse" "mautrix-discord" "mautrix-signal" ];
    ensureUsers = [
      {
        name = "matrix-synapse";
        ensureDBOwnership = true;
      }
      {
        name = "mautrix-discord";
        ensureDBOwnership = true;
      }
      {
        name = "mautrix-signal";
        ensureDBOwnership = true;
      }
    ];
  };

  services = {
    mautrix-discord = {
      enable = true;
      registerToSynapse = true;
      settings = {
        homeserver = {
          address = "http://localhost:8008";
          domain = "convene.chat";
        };

        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///mautrix-discord?host=/run/postgresql";
          };
        };

        bridge = {
          permissions = {
            "convene.chat" = "user";
            "@ayes:convene.chat" = "admin";
          };
        };
      };

    };

    mautrix-signal = {
      enable = true;
      registerToSynapse = true;
      settings = {
        homeserver = {
          address = "http://localhost:8008";
          domain = "convene.chat";
        };

        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///mautrix-signal?host=/run/postgresql";
          };
        };

        bridge = {
          permissions = {
            "convene.chat" = "user";
            "@ayes:convene.chat" = "admin";
          };
        };
      };
    };
  };

  /*services.livekit = {
    enable = true;
    openFirewall = true;
    settings.room.auto_create = false;
  };*/

  environment.systemPackages = with pkgs; [
    lottieconverter
  ];

  users.users.matrix-synapse.extraGroups = [ "mautrix-discord" "mautrix-signal" ];
}
