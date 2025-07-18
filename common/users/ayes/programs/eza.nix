{
  programs.eza = {
    enable = true;
    colors = "always";
    icons = "auto";
  };

  programs.fish = {
    shellAliases = {
      ls = "eza -a";
    };
  };
}
