{
  # Example dev counterpart. Disabled by default; kept private (no firewall) so
  # it is never auto-protected and never conflicts with the live port.
  services.minecraft-servers.servers.example-dev = {
    enable = false;
    openFirewall = false;

    serverProperties = {
      server-port = 35566;
      gamemode = 0;
      difficulty = 3;
      max-players = 1;
    };
  };
}
