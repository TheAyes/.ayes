{
  programs.fish = {
    enable = true;

    shellAliases = {
      rebuild = "nixos-rebuild switch --use-remote-sudo --flake $(git rev-parse --show-toplevel)";
      #test = "nixos-rebuild test --use-remote-sudo --flake $(git rev-parse --show-toplevel)";
    };
  };
}
