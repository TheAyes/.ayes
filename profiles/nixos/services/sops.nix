# Shared sops-nix configuration for all hosts
# Each host should set sops.defaultSopsFile and sops.secrets as needed
{ ... }:

rec {
  sops = {
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
    };
  };

  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = sops.age.keyFile;
  };
}
