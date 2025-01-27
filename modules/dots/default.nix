{
  config,
  lib,
  ...
}: {
  options = {
    dots = {
      system = {
      };
      # Shells
      # Todo: bash = lib.mkEnableOption "bash";
      # Todo: zsh = lib.mkEnableOption "zsh";
      # Todo: fish = lib.mkEnableOption "fish";

      # WM's
      # Todo: hyprland = lib.mkEnableOption "hyprland";

      # Programs
      # Todo: steam = lib.mkEnableOption "steam";
    };
  };

  config = {
  };
}
