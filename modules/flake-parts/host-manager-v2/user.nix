{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types optionals literalExpression mapAttrs concatMapAttrs;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable this user for this host";
      example = false;
    };

    importBase = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to import the base profile for this user for this host";
      example = false;
    };

    groups = mkOption {
      type = types.listOf str;
      default = [];
      description = "A list of strings declaring the groups this user is part in";
      example = [
        "wheel"
        "networkmanager"
      ];
    };

    home-manager = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether or not to enable home-manager for this user.";
        example = false;
      };
    };
  };
}
