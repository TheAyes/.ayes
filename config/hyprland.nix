{
	"$mainMod" = "SUPER";
	
	source = [];

	env = [
		"XCURSOR_SIZE, 24"
		"HYPRCURSOR_SIZE, 24"

		"QT_QPA_PLATFORMTHEME, qt6ct"

		"XDG_SESSION_TYPE, wayland"
		"LIBVA_DRIVER_NAME, nvidia"
		"__GLX_VENDOR_LIBRARY_NAME, nvidia"
		"GBM_BACKEND, nvidia-drm"
		"NVD_BACKEND, direct"
		"WLR_NO_HARDWARE_CURSORS, 1"
	];

	monitor = [
		"HDMI-A-1, preferred, 0x0, auto"
		"DP-1, preferred, 1920x0, auto"
		"DP-2, preferred, -1920x0, auto"
	];

	#workspace = (
	#	builtins.concatLists(
	#		builtins.genList(
	#			
	#		)
	#	)
	#)

	exec-once = [
		"firefox"
		"vesktop"
		"nwg-panel"
	];

	input = {
		kb_layout = "de";
		kb_variant = "nodeadkeys";

		follow_mouse = "1";

		touchpad = {
			natural_scroll = "no";
		};

		sensitivity = "0";
	};

	bind = [
		"$mainMod, Q, exec, kitty"
		"$mainMod, C, killactive," 
		"$mainMod, M, exit,"
		"$mainMod, E, exec, dolphin"
		"$mainMod, V, togglefloating," 
		"$mainMod, R, exec, wofi --show drun"
		"$mainMod, P, pseudo, # dwindle"
		"$mainMod, J, togglesplit, # dwindle"
		"$mainMod, F, fullscreen"
		", Print, exec, hyprshot -m region --clipboard-only"

		"$mainMod, S, togglespecialworkspace, magic"
		"$mainMod SHIFT, S, movetoworkspace, special:magic"
	] ++ (
		builtins.concatLists(
			builtins.genList(
				x: let
					ws = let
						c = (x + 1) / 10;
					in
						builtins.toString(x + 1 - (x * 10));
				in [
					"$mainMod, ${ws}, workspace, ${toString(x + 1)}"
					"$mainMod SHIFT, ${ws}, movetoworkspace, ${toString(x + 1)}"
				]
			)
			10
		)
	);

	bindl = [
		", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
		", XF86AudioNext, exec, playerctl next"
		", XF86AudioPrev, exec, playerctl previous"
		", XF86AudioPlay, exec, playerctl play-pause"
		", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
		", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
	];

	bindel = [
		
	];

	bindm = [
		"$mainMod, mouse:272, movewindow"
		"$mainMod, mouse:273, resizewindow"
	];

	general = {
		gaps_in = 5;
		gaps_out = 20;
		border_size = 2;
		"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
		"col.inactive_border" = "rgba(595959aa)";

		layout = "dwindle";

		# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
		allow_tearing = false;
		resize_on_border = true;
		#default_cursor_monitor = "HDMI-A-1";
	};

	decoration = {
		rounding = 10;

		blur = {
			enabled = true;
			size = 6;
			passes = 1;
		};

		drop_shadow = "yes";
		shadow_range = 4;
		shadow_render_power = 3;
		"col.shadow" = "rgba(1a1a1aee)";
	};

	animations = {
		enabled = "yes";

		bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

		animation = [
			"windows, 1, 7, myBezier"
			"windowsOut, 1, 7, default, popin 80%"
			"border, 1, 10, default"
			"borderangle, 1, 8, default"
			"fade, 1, 7, default"
			"workspaces, 1, 6, default"
		];
	};

	dwindle = {
		pseudotile = "yes";
		preserve_split = "yes";
	};

	master = {
		new_is_master = true;
	};

	gestures = {
		workspace_swipe = "off";
	};

	misc = {
		force_default_wallpaper = -1;
	};

	windowrulev2 = [
		"nofocus, noinitialfocus, class:^$, title:^$"
	];
}
