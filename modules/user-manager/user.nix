{
  lib,
  config,
  user,
  ...
}: {
  options = {
    groups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      example = "[ wheel, network-manager ]";
    };
  };

  config = {
    users.users.${user} = lib.mkMerge {
      extraGroups = config.groups;
    };
  };
}
