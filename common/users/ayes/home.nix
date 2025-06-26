{pkgs, ...}: {
  imports = [
    ./programs/git.nix

    ../../../presets/home-manager/programs/fish.nix
    ../../../presets/home-manager/programs/direnv.nix
  ];

  home = {
    pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      dotIcons.enable = true;

      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };

    sessionVariables = {
      GIT_MERGE_AUTOEDIT = "no";
    };

    packages = with pkgs; [
      # Documentation and Writing
      obsidian
    ];

    file = {
      "xiv-config" = {
        enable = true;

        source = ./external/xlcore;
        target = ".xlcore";
      };
    };
  };
}
