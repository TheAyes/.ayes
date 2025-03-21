{ lib, config, pkgs, ... }: {
  options = {
    programs.xivlauncher = {
      enable = lib.mkEnableOption "XIV Launcher";
    };
  };

  config = lib.mkIf config.xiv-manager.enable {
    home.packages = with pkgs; [
      xivlauncher
    ];
  };
}
