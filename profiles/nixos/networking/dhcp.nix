{ ... }:
{
  networking = {
    useDHCP = true;
    dhcpcd.extraConfig = "nohostname"; # Prevent DHCP from overriding hostname
  };
}
