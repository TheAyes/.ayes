{ pkgs, ... }: {
  imports = [
    ./programs/git.nix

    ../../../presets/home-manager/programs/fish.nix
    ../../../presets/home-manager/programs/direnv.nix
  ];

  home.packages = with pkgs; [
    # Gaming
    xivlauncher
    prismlauncher
    heroic
  ];
}
