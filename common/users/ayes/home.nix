{pkgs, ...}: {
  imports = [
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/fish.nix
    ./programs/eza.nix
    ./programs/zoxide.nix

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
  };
}
