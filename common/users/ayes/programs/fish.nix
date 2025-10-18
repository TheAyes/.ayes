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
			#apply-tide = lib.hm.dag.entryAfter ["writeBoundary"] ''
			#	run tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Dotted --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
			#'';
		};

  };
}
