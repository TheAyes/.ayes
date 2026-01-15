{
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption types optionals literalExpression mapAttrs concatMapAttrs;
in {
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable host-manager";
      example = true;
    };

    root = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The root from which configurations are being imported";
      example = literalExpression "./.";
    };

    hostsPath = mkOption {
      type = types.path;
      default = /hosts;
      description = "The location for where your host-files are going to reside in";
      example = /some/other/host/path;
    };

    hosts = mkOption {
      type = with types; attrsOf (submoduleWith {modules = [./host.nix];});
    };

    usersPath = mkOption {
      type = types.path;
      default = /users;
      description = "The location for where your user-files are going to reside in";
      example = /some/other/user/path;
    };

    globalUsers = mkOption {
      type = with types; attrsOf (submoduleWith {modules = [./user.nix];});
      default = {};
      description = "Users to be created across all hosts";
      example = {
        moderator = {
          enable = true;
          /*
          ...more config...
          */
        };
      };
    };

    nixos = {
      input = mkOption {
        type = types.deferredModule;
        default = inputs.nixpkgs;
        description = "The input to take for nixpkgs";
        example = inputs.nixpkgs-unstable;
      };

      globalNixosModules = mkOption {
        type = with types; listOf deferredModule;
        default = [];
        description = "Extra modules that will be imported for all hosts managed by host-manager";
        example = [
          inputs.sops-nix.nixosModules.sops
          inputs.solaar.nixosModules.default
          ./modules/nixos/my-custom-module
        ];
      };
    };

    home-manager = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable home-manager";
        example = true;
      };

      input = mkOption {
        type = types.deferredModule;
        default = inputs.home-manager;
        description = "The input to take for home-manager";
        example = inputs.home-manager-unstable;
      };

      globalHomeManagerModules = mkOption {
        type = with types; listOf deferredModule;
        default = [];
        description = "Extra modules that will be imported for all home-manager users across all hosts managed by host-manager";
        example = [
          inputs.nixcord.homeModules.nixcord
          inputs.zen-browser.homeModules.twilight
          ./modules/home-manager/my-custom-module
        ];
      };
    };
  };
}
