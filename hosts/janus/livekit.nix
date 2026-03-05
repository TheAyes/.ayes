{ config, lib, ... }:

{
  services.livekit = {
    enable = true;
    openFirewall = true;
    settings.room.auto_create = false;
    keyFile = config.sops.templates."livekit-keyfile".path;

    settings.turn = {
      enabled = true;
      domain = "turn.convene.chat";
      udp_port = 3479;
      tls_port = 5349;
      relay_range_start = 52000;
      relay_range_end = 53000;
      cert_file = "/var/lib/acme/turn.convene.chat/cert.pem";
      key_file = "/var/lib/acme/turn.convene.chat/key.pem";
    };
  };

  users.users.livekit = {
    isSystemUser = true;
    group = "livekit";
  };
  users.groups.livekit = {};

  systemd.services.livekit.serviceConfig = {
    DynamicUser = lib.mkForce false;
    PrivateUsers = lib.mkForce false;
    User = lib.mkForce "livekit";
    Group = lib.mkForce "livekit";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin.ashen010@passmail.net";
    certs."turn.convene.chat" = {
      group = "livekit";
      listenHTTP = ":8402";
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 3479 ];
    allowedTCPPorts = [ 5349 ];
    allowedUDPPortRanges = [{ from = 52000; to = 53000; }];
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://convene.chat/livekit/sfu";
    keyFile = config.sops.templates."livekit-keyfile".path;
  };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "convene.chat";
}
