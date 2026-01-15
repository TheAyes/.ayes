{
  flake-parts-lib,
  nixpkgs-lib,
  ...
}: {
  lib,
  inputs,
  ...
}:
assert inputs.nixpkgs || throw "'inputs.nixpkgs' was not given. Host-Manager cannot build configurations without it."; {
  imports = [
  ];

  options.host-manager = lib.mkOption {
    type = lib.types.submoduleWith [{modules = [./host-manager.nix];}];
    description = "This is where you configure your host-management options";
  };

  config.flake = lib.mkIf config.host-manager.enable {
    nixosConfigurations = lib.mapAttrs (hostname: hostConfig:
      lib.nixosSystem {
        modules = [
        ];
      })
    config.host-manager.hosts;
  };
}
