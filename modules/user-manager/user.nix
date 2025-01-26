{ lib, ... }: {
  options = {
    groups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [ "wheel" "network-manager" ];
    };


    home-manager = {
      enable = lib.mkEnableOption "Home Manager";

      extraModules = lib.mkOption {
        type = with lib.types; listOf deferredModule;
        default = [ ];
        example = lib.literalExpression [ ./my-module.nix ];
      };
    };
  };
}
