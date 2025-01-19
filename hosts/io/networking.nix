{host, ...}: {
  networking = {
    hostName = host;

    wireless = {
      userControlled.enable = true;
      iwd = {
        enable = true;
        settings = {
          IPv6.enabled = true;
          Settings.Autoconnect = true;
          Settings.AlwaysRandomizeAddress = true;
        };
      };
    };

    nameservers = ["8.8.8.8" "1.1.1.1"];

    firewall = {
      enable = true;
      #allowedTCPPorts = [];
      #allowedUDPPorts = [];
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
    dnsovertls = "true";
  };
}
