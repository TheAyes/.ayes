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
  # No modpack is configured yet. When a new pack is set up, enable and add an
  # entry per live server. `host` is an SSH destination (add a matching entry to
  # programs.ssh, or use a reachable user@address); set host = null for an
  # endpoint local to where the command runs.
  #
  #   programs.mcWorldSync = {
  #     enable = true;
  #     servers.<name> = {
  #       live = { host = "io"; dataDir = "/srv/minecraft/<name>"; };
  #       dev  = { host = "io"; dataDir = "/srv/minecraft/<name>-dev"; };
  #     };
  #   };

  home = {
    sessionVariables = {
      GIT_MERGE_AUTOEDIT = "no";
    };

    packages = with pkgs; [
      obsidian
    ];
  };
}
