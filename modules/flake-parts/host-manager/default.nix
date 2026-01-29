{ lib
, config
, inputs
, self
, ...
}: {
  options = {
    host-manager = {
      enable = lib.mkEnableOption "the host-manager module";

      hostDir = lib.mkOption {
        type = lib.types.path;
        default = ../../../hosts;
      };

      userDir = lib.mkOption {
        type = lib.types.path;
        default = ../../../users;
      };

      sharedHostModules = lib.mkOption {
        type = with lib.types; listOf deferredModule;
        description = "Extra modules that will be shared between all hosts";
        default = [ ];
      };

      hosts = lib.mkOption {
        type = with lib.types;
          attrsOf (submoduleWith {
            modules = [ ./host.nix ];
          });
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
                let
                  makeOptionalImport = file: lib.optional (builtins.pathExists file) file;
                in
                makeOptionalImport (config.host-manager.hostDir + /base.nix)
                ++ [
                  (config.host-manager.hostDir + /${hostname}/configuration.nix)

                  {
                    users.users =
                      lib.mapAttrs
                        (username: userConfig: {
                          isNormalUser = true;
                          extraGroups = userConfig.groups;
                        })
                        hostConfig.users;
                  }
                ] ++ (lib.optionals hostConfig.home-manager.enable [
                  (inputs.home-manager.nixosModules.home-manager)

                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      backupFileExtension = "bak";
                      backupCommand = "${inputs.nixpkgs.legacyPackages.${hostConfig.systemType}.trash-cli}/bin/trash";

                      extraSpecialArgs = {
                        inherit inputs self;
                        system = hostConfig.systemType;
                      };
                      sharedModules =
                        hostConfig.home-manager.sharedModules ++ config.host-manager.home-manager.globalModules;

                      users =
                        lib.concatMapAttrs
                          (username: userConfig:
                            lib.optionalAttrs userConfig.home-manager.enable {
                              ${username} = {
                                imports =
                                  # Base user config
                                  makeOptionalImport (config.host-manager.userDir + /base.nix)
                                  # Common user config (across all machines)
                                  ++ [
                                    (config.host-manager.userDir + /${username}/home.nix)
                                  ]
                                  # Host specific user config)
                                  ++ makeOptionalImport (config.host-manager.hostDir + /${hostname}/base-user.nix)
                                  ++ makeOptionalImport (config.host-manager.userDir + /${username}/hosts/${hostname})
                                  ++ makeOptionalImport (config.host-manager.userDir + /${username}/hosts/${hostname}/home.nix);
                              };
                            }
                          )
                          hostConfig.users;
                    };
                  }
                ])
                ++ hostConfig.extraModules
                ++ config.host-manager.sharedHostModules;
              system = hostConfig.systemType;
              specialArgs = {
                inherit inputs hostname;
                system = hostConfig.systemType;
              };
            }
        )
        config.host-manager.hosts;
  };
}
