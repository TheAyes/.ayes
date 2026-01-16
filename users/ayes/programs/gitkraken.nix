{ pkgs, self, ... }:
{
  home.packages = with pkgs; [ gitkraken ];
  home.file.themes = {
    enable = true;
    source = "${self}/assets/themes/gitkraken";
    recursive = true;
    target = "./.gitkraken/themes/";
  };
}
