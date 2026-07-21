{
  # Example live server. Disabled by default so it doesn't run.
  #
  # To make it a real, publicly reachable server:
  #   - remove `enable = false;` (the baseline enables it by default), and
  #   - set `openFirewall = true;` — protection.nix then automatically adds
  #     fail2ban jails and connection rate-limiting for its port.
  #
  # Everything not set here comes from the baseline.
  services.minecraft-servers.servers.example = {
    enable = false;
    openFirewall = false;

    serverProperties = {
      server-port = 25566;
      gamemode = 0;
      difficulty = 3;
      max-players = 8;
    };

    # Add extra players on top of the baseline admin whitelist:
    # whitelist = { SomePlayer = "<uuid>"; };
  };
}
