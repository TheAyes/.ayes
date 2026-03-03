{ config, ... }:

{
  services.coturn = {
    enable = true;
    realm = "convene.chat";
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets."coturn/static_auth_secret".path;

    listening-port = 3478;
    min-port = 49000;
    max-port = 50000;

    no-tls = true;
    no-dtls = true;
    no-cli = true;

    extraConfig = ''
      denied-peer-ip=10.0.0.0-10.255.255.255
      denied-peer-ip=192.168.0.0-192.168.255.255
      denied-peer-ip=172.16.0.0-172.31.255.255
      denied-peer-ip=127.0.0.0-127.255.255.255
      denied-peer-ip=0.0.0.0-0.255.255.255
      denied-peer-ip=169.254.0.0-169.254.255.255
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 3478 ];
    allowedUDPPorts = [ 3478 ];
    allowedUDPPortRanges = [{ from = 49000; to = 50000; }];
  };
}
