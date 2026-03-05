{ config, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "matrix.convene.chat" = {
        extraConfig = ''
          reverse_proxy /_matrix/* http://127.0.0.1:8008
          reverse_proxy /_synapse/client/* http://127.0.0.1:8008
        '';
      };

      "http://turn.convene.chat" = {
        extraConfig = ''
          reverse_proxy /.well-known/acme-challenge/* http://127.0.0.1:8402
        '';
      };

      # .well-known for federation and LiveKit discovery
      "convene.chat" = {
        extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          respond /.well-known/matrix/server `{"m.server": "matrix.convene.chat:443"}`
          respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.convene.chat"}, "org.matrix.msc4143.rtc_foci": [{"type": "livekit", "livekit_service_url": "https://convene.chat/livekit/jwt"}]}`

          # LiveKit JWT service (strip /livekit/jwt prefix)
          handle_path /livekit/jwt/* {
            reverse_proxy http://[::1]:${toString config.services.lk-jwt-service.port}
          }

          # LiveKit SFU (WebSocket, strip /livekit/sfu prefix)
          handle_path /livekit/sfu/* {
            reverse_proxy http://[::1]:${toString config.services.livekit.settings.port} {
              header_up Connection {>Connection}
              header_up Upgrade {>Upgrade}
            }
          }
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
