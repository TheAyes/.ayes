{
  inputs,
  config,
  lib,
  ...
}: {
  options = {
    user-manager = lib.mkOption {
      type = with lib.types;
        attrsOf (name:
          submoduleWith {
            modules = [./user.nix];
            specialArgs = {user = name;};
          });
    };
  };

  config = {
  };
}
