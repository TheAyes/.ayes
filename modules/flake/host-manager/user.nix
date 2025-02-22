{lib, ...}: {
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    groups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      example = ["wheel" "network-manager"];
    };

    home-manager = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether or not to enable home-manager for this user.";
      };
    };
  };
}
