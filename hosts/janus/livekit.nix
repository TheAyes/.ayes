{ config, ... }:

{
  services.livekit = {
    enable = true;
    openFirewall = true;
    settings.room.auto_create = false;
    keyFile = config.sops.templates."livekit-keyfile".path;
  };

  services.lk-jwt-service = {
    enable = true;
    livekitUrl = "wss://convene.chat/livekit/sfu";
    keyFile = config.sops.templates."livekit-keyfile".path;
  };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = "convene.chat";
}
