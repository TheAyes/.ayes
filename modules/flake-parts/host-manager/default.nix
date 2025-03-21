{ lib
, config
, inputs
, ...
}: {
  options = {
    host-manager = {
      enable = lib.mkEnableOption "the host-manager module";

      baseDir = lib.mkOption {
        type = lib.types.path;
        default = ../../../hosts;
      };

      hosts = lib.mkOption {
        type = with lib.types; attrsOf (submoduleWith { modules = [ ./host.nix ]; });
        default = { };
      };

      home-manager = {
        globalModules = lib.mkOption {
          type = with lib.types; listOf deferredModule;
          default = [ ];
        };
      };
    };
  };

  config.flake = lib.mkIf config.host-manager.enable {
    nixosConfigurations =
      lib.mapAttrs
        (
          hostname: hostConfig:
            inputs.nixpkgs.lib.nixosSystem {
              modules =
                [
                  ../../../hosts/base.nix
                  (config.host-manager.baseDir + "/${hostname}/configuration.nix")

                  {
                    users.users =
                      lib.mapAttrs
                        (username: userConfig: {
                          isNormalUser = true;
                          extraGroups = userConfig.groups;
                        })
                        hostConfig.users;
                  }

                  (inputs.home-manager.nixosModules.home-manager)

                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      sharedModules = hostConfig.home-manager.sharedModules ++ config.host-manager.home-manager.globalModules;

                      users = lib.concatMapAttrs
                        (username: userConfig: {
                          ${username} = {
                            imports = [
                              (
                                if userConfig.home-manager.enable then
                                  ../../../hosts/${hostname}/users/${username}/home.nix
                                else null
                              )
                            ];

                            home = {
                              homeDirectory = "/home/${username}";
                              stateVersion = "23.11";
                            };
                          };
                        })
                        hostConfig.users;
                    };
                  }
                ]
                ++ hostConfig.extraModules;
              system = hostConfig.systemType;
              specialArgs = {
                inherit inputs hostname;
              };
            }
        )
        config.host-manager.hosts;
  };
}
