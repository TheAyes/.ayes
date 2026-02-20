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

      # .well-known for federation (allows matrix.convene.chat as server name)
      "convene.chat" = {
        extraConfig = ''
          header /.well-known/matrix/* Content-Type application/json
          respond /.well-known/matrix/server `{"m.server": "matrix.convene.chat:443"}`
          respond /.well-known/matrix/client `{"m.homeserver": {"base_url": "https://matrix.convene.chat"}}`
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
