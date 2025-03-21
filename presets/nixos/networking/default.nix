{ hostname, ... }: {
  networking = {
    hostName = hostname;

    networkmanager.enable = true;

    firewall = {
      enable = true; # Ensure the firewall is enabled
      #allowedTCPPorts = [ 3000 ];
    };

  };
}
