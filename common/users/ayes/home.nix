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
    graalvm-ce
    heroic

    # Music Production
    bitwig-studio

    # Documentation and Writing
    obsidian
  ];
}
