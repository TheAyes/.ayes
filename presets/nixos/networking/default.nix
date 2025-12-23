{ hostname, ... }:
{
  networking = {
    hostName = hostname;

    networkmanager.enable = true;
    networkmanager.dns = "none";

    nameservers = [
      "172.64.36.1"
      "172.64.36.2"
      "2a06:98c1:54::1e:e29b"
    ];

    firewall = {
      enable = true; # Ensure the firewall is enabled

      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
  };
}
