{ ... }:
{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "catppuccin-mocha";
      theme_background = false;
      proc_gradient = false;
      update_ms = 500;
    };
    themes = {
      catppuccin-mocha = ../../../assets/themes/btop/catppuccin-mocha.theme;
    };
  };
}
