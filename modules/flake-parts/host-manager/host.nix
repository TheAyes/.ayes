{ lib, ... }: {
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    home-manager = {
      enable = lib.mkEnableOption "Home Manager";
      sharedModules = lib.mkOption {
        type = with lib.types; listOf deferredModule; # According to Nobbz: This could lead to unexpected errors - consider using unspecified instead
        default = [ ];
      };
    };

    systemType = lib.mkOption {
      type = lib.types.enum [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      default = "x86_64-linux";
    };

    users = lib.mkOption {
      type = with lib.types; attrsOf (submoduleWith { modules = [ ./user.nix ]; });
      default = { };
    };

    extraModules = lib.mkOption {
      type = with lib.types; listOf deferredModule; # According to Nobbz: This could lead to unexpected errors - consider using unspecified instead
      default = [ ];
    };
  };
}
