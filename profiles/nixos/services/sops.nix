# Shared sops-nix configuration for all hosts
# Each host should set sops.defaultSopsFile and sops.secrets as needed
{ config, lib, ... }:

{
  sops = {
    defaultSopsFormat = "yaml";

    age = {
      # System-level key - available at boot, before user login
      # Generate with: age-keygen -o /var/lib/sops-nix/key.txt
      # Use mkDefault so hosts can override during migration
      keyFile = lib.mkDefault "/var/lib/sops-nix/key.txt";
    };
  };
}
