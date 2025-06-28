{ pkgs, ... }: {
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;

    settings = {
      color_theme = "catppuccin-mocha";
      theme_background = false;
      proc_gradient = false;
      update_ms = 500;
    };
  };

  xdg.configFile.btop-catppuccin-theme = {
    enable = true;
    source = ../../../../assets/themes/btop/catppuccin-mocha.theme;
    target = "./btop/themes/catppuccin-mocha.theme";
  };
}
