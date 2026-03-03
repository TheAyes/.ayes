# Shared sops-nix configuration for all hosts
# Each host should set sops.defaultSopsFile and sops.secrets as needed
{ config, lib, ... }:

{
  sops = {
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
  };
}
