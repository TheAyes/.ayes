{hostname, ...}: {
  networking = {
    hostName = hostname;

    networkmanager.enable = true;
    networkmanager.dns = "none";

    nameservers = ["172.64.36.1" "172.64.36.2" "2a06:98c1:54::1e:e214"];

    firewall = {
      enable = true; # Ensure the firewall is enabled
      allowedTCPPorts = [25565];
      allowedUDPPorts = [24454];
      extraCommands = ''
        iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -m limit --limit 5/min --limit-burst 10 -j ACCEPT
        iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -j DROP
      '';
      logRefusedConnections = true;
      logRefusedPackets = true;
      logReversePathDrops = true;
    };
  };
}
