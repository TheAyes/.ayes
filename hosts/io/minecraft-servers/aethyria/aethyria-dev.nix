{
  # Aethyria dev counterpart. Always private (no firewall) so it's never
  # auto-protected and never conflicts with the live port. Synced from live
  # via `mc-world-pull aethyria` / pushed back via `mc-world-push aethyria`.
  services.minecraft-servers.servers.aethyria-dev = {
    openFirewall = false;

    serverProperties = {
      server-port = 25575;
      gamemode = 0;
      difficulty = 3;
      max-players = 1;
    };
  };
}
