{
  inputs,
  config,
  lib,
  ...
}: let
  mkSystemUser = user: {
    imports = lib.mkMerge [
      inputs.home-manager.nixosModules.home-manager
    ];

    users.users = {
      "${user.id}" = {
        isNormalUser = true;
        description = user.displayName or "";
        group = "users";
        extraGroups = user.groups or [];
      };
    };
  };

  mkHomeManagerUser = user: {
    home-manager.users."${user.id}" = rec {
      home = {
        username = user.id;
        homeDirectory = "/home/${user.id}";
        stateVersion = "23.11";
      };

      imports = lib.concatLists [
        [home.homeDirectory]
        (lib.attrValues (user.extraModules or {}))
      ];
    };
  };
in {
  options = {
    ayes-man.users = lib.mkOption {
      type = with lib.types;
        listOf (attrsOf {
          id = str;
          displayName = str;
          useHomeManager = bool;
          groups = listOf str;
          extraModules = attrsOf path;
        });
      default = [];
      defaultText = "[]";
      example = ''
        [
          {
            id = "alice";
            displayName = "Alice Doe";
            useHomeManager = true;
          },
          {
            id = "bob";
            displayName = "Bob Smith";
            groups = ["wheel"];
            useHomeManager = false;
          }
        ]
      '';
    };
  };

  config = lib.mkIf (config.ayes-man.users != []) (
    let
      userConfigs =
        map (
          user:
            lib.mkMerge [
              (mkSystemUser user)

              /*
              (lib.mkIf user.useHomeManager (mkHomeManagerUser user))
              */
            ]
        )
        config.ayes-man.users;
    in
      lib.mkMerge userConfigs
  );
}
