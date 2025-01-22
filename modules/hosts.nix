{lib, ...}: let
  customTypes = import ./types.nix;
  mkHost = host: {
  };
in {
  option = {
    hosts = {
      type =
        lib.mkOption {
        };
    };
  };
}
