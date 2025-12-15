{ pkgs, lib, ... }:
{
  imports = [
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/fish.nix
    ./programs/eza.nix
    ./programs/zoxide.nix

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

  # stylix = {
  #   cursor = {
  #     name = "Bibata-Modern-Ice";
  #     package = pkgs.bibata-cursors;
  #     size = 14;
  #   };

  #   autoEnable = false;
  #   targets = {
  #     gtk.enable = true;
  #     qt.enable = true;

  #     nixcord.enable = false;
  #     vencord.enable = false;
  #     vesktop.enable = false;

  #     btop.enable = true;
  #     micro.enable = true;

  #     vicinae.enable = false;

  #   };
  # };
}
