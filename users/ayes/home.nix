{ pkgs
, lib
, ...
}:
{
  imports = [
    ../../profiles/home-manager/programs/fish.nix
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/eza.nix
    ./programs/zoxide.nix
    ./programs/zed/config.nix
    ./programs/gitkraken.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    silent = true;
  };

  home = {
    sessionVariables = {
      GIT_MERGE_AUTOEDIT = "no";
    };

    packages = with pkgs; [
      obsidian
    ];
  };
}
