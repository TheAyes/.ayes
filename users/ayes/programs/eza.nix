{
  programs.eza = {
    enable = true;
    colors = "auto";
    icons = "auto";
  };

  programs.fish = {
    shellAliases = {
      ls = "eza -a";
    };
  };
}
