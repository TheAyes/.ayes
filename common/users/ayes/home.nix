{ pkgs, lib, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/fish.nix
    ./programs/eza.nix
    ./programs/zoxide.nix
    ./programs/zed/config.nix

    #../../../presets/home-manager/programs/fish.nix
    ../../../presets/home-manager/programs/direnv.nix
  ];

  home = {
    sessionVariables = {
      GIT_MERGE_AUTOEDIT = "no";
    };

    packages = with pkgs; [
      # Documentation and Writing
      obsidian
    ];
  };

  home.pointerCursor = lib.mkDefault {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 14;
  };
  gtk = lib.mkDefault {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 14;
    };
  };

}
