{ hostname, ... }:
{
  imports = [
    ./firewall.nix
    ./nameservers.nix
    ./networkmanager.nix
  ];

  networking.hostName = hostname;
}
