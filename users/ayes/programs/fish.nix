{pkgs, lib, ...}: {
  programs.fish = {
    enable = true;

    shellInit = ''
    '';

    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      microfetch
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

  home = {
		packages = with pkgs; [
		  grc
		  microfetch
		];

		activation = {
			#applyTide = lib.hm.dag.entryAfter ["writeBoundary"] ''
			#	echo "Hello there!"
			#	run touch /tmp/test.file
			#'';
		};

  };
}
