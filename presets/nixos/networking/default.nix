{ hostname, ... }: {
  networking = {
    hostName = hostname;

    networkmanager.enable = true;

    firewall = {
      enable = true; # Ensure the firewall is enabled
      allowedTCPPorts = [ 25565 ];
      allowedUDPPorts = [ 24454 ];
      extraCommands = ''
        iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -m limit --limit 5/min --limit-burst 10 -j ACCEPT
        iptables -A INPUT -p tcp --dport 25565 -m conntrack --ctstate NEW -j DROP
      '';

    };

  };
}
