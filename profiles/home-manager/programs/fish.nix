{ lib, pkgs, ... }: {
  programs = {
    fish = {
      enable = lib.mkDefault true;
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

      interactiveShellInit = ''
        	  set fish_greeting # Disable greeting
        	  microfetch
      '';
    };
  };
  home.packages = with pkgs; [
    grc
    microfetch
  ];
}
