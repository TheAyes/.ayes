{lib, ...}: {
  options.host-manager.hosts = lib.mkOption {
    type = with lib.types;
      attrsOf submodule {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable this host";
          example = false;
        };
        systemType = lib.mkOption {
          type = lib.types.enum ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
          default = "x86_64-linux";
          description = "The system type this host has";
          example = "aarch64-linux";
        };
      };
    default = {};
    example = {
      my-machine = {
        enable = true;
        /*
        ...more config...
        */
      };

      my-server = {
        enable = true;
        /*
        ...more config...
        */
      };
    };
    description = "Here you can configure your hosts.";
  };

  config.flake = lib.mkIf config.host-manager.enable {
    nixosConfigurations = lib.mapAttrs (hostname: hostConfig:
      lib.nixosSystem {
        modules =
          ######################## NixOS Modules ########################
          hostConfig.nixos.globalNixosModules
          ##################### HomeManager Modules #####################
          ++ [
            (lib.mkIf hostConfig.home-manager.enable {
              home-manager = {sharedModules = hostConfig.home-manager.globalHomeManagerModules;};
            })
          ];
        #################################################################
      })
    config.host-manager.hosts;
  };
}
