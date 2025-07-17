{pkgs, ...}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      ls = "eza";
    };

    shellInit = ''
    '';

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';

    plugins = with pkgs.fishPlugins; [
      {
        name = "tide";
        src = tide.src;
      }
      {
        name = "grc";
        src = grc.src;
      }
    ];
  };

  home.packages = with pkgs; [
    grc
  ];
}
