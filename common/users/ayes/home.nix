{ pkgs, ... }: {
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

    packages = with pkgs; [
      # Documentation and Writing
      obsidian
    ];

    file = {
      "xiv-config" =  {
        enable = false; # Broken until hm decides to actual make it useful
        recursive = true;

        source = "./external/xlcore";
        target = ".xlcore";
      };
    };
  };
}
