{ ... }:
{
  networking.firewall = {
    enable = true;
    logRefusedConnections = true;
    logRefusedPackets = true;
    logReversePathDrops = true;
  };
}
