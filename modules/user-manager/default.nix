{ config
, lib
, systemStateVersion ? "23.11"
, ...
}: {
  options = {
    user-manager = lib.mkOption {
      type = with lib.types;
        attrsOf (submoduleWith { modules = [ ./user.nix ]; });
      default = { };
    };
  };

  config = {
    users.users =
      lib.mapAttrs
        (name: value: {
          isNormalUser = true;
          extraGroups = value.groups;
        })
        config.user-manager;

    home-manager =
      lib.concatMapAttrs
        (name: value: {
          users = lib.mkIf value.home-manager.enable {
            ${name} = {
              imports = [ ../../home/${name} ] ++ value.home-manager.extraModules;

              home = {
                homeDirectory = "/home/${name}";
                stateVersion = systemStateVersion;
              };
            };
          };
        })
        config.user-manager;
  };
}
