{
  pkgs,
  ...
}:
{
  imports = [
    ../../profiles/home-manager/programs/fish.nix
    ./programs/git.nix
    ./programs/ssh.nix
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

  # Live⇄dev Minecraft sync: `mc-world-pull <server>` / `mc-world-push <server>`.
  # host = null since both aethyria and aethyria-dev run on io, the same
  # machine this home-manager config applies to.
  programs.mcWorldSync = {
    enable = true;
    servers.aethyria = {
      live = {
        host = null;
        dataDir = "/srv/minecraft/aethyria";
      };
      dev = {
        host = null;
        dataDir = "/srv/minecraft/aethyria-dev";
      };
    };
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
