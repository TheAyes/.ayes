{
  # Aethyria live server. Private for now (LAN/VPN only) — flip openFirewall
  # to true once it should be reachable from the internet; protection.nix will
  # then automatically add fail2ban jails and connection rate-limiting for it.
  services.minecraft-servers.servers.aethyria = {
    openFirewall = false;

    serverProperties = {
      server-port = 25565;
      gamemode = 0;
      difficulty = 3;
      max-players = 20;
    };

    # Add extra players on top of the baseline admin whitelist:
    # whitelist = { SomePlayer = "<uuid>"; };
  };
}
