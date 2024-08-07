{
	imports = [
		./hyprland.home.nix
	];

	wayland.windowManager.hyprland.settings = {
		"$mainMod" = "SUPER";

		source = [];

		env = [
			"WLR_NO_HARDWARE_CURSORS, 1"
		];

		exec-once = [
			"ags -c /home/ayes/.nixos/config/ags/config.js"
			"firefox"
			"vesktop"
			"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
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

			"$mainMod, Right, movefocus, r"
			"$mainMod, Left, movefocus, l"

			"$mainMod, S, togglespecialworkspace, magic"
			"$mainMod SHIFT, S, movetoworkspace, special:magic"
		] ++ [
			"$mainMod, 1, exec, hyprsome workspace 1"
			"$mainMod, 2, exec, hyprsome workspace 2"
			"$mainMod, 3, exec, hyprsome workspace 3"
			"$mainMod, 4, exec, hyprsome workspace 4"
			"$mainMod, 5, exec, hyprsome workspace 5"
			"$mainMod, 6, exec, hyprsome workspace 6"
			"$mainMod, 7, exec, hyprsome workspace 7"
			"$mainMod, 8, exec, hyprsome workspace 8"
			"$mainMod, 9, exec, hyprsome workspace 9"
			"$mainMod SHIFT, 1, exec, hyprsome move 1"
			"$mainMod SHIFT, 2, exec, hyprsome move 2"
			"$mainMod SHIFT, 3, exec, hyprsome move 3"
			"$mainMod SHIFT, 4, exec, hyprsome move 4"
			"$mainMod SHIFT, 5, exec, hyprsome move 5"
			"$mainMod SHIFT, 6, exec, hyprsome move 6"
			"$mainMod SHIFT, 7, exec, hyprsome move 7"
			"$mainMod SHIFT, 8, exec, hyprsome move 8"
			"$mainMod SHIFT, 9, exec, hyprsome move 9"
		];

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
				size = 12;
				passes = 3;
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

		gestures = {
			workspace_swipe = "off";
		};

		misc = {
			force_default_wallpaper = -1;
		};

		windowrulev2 = [
			"nofocus, noinitialfocus, class:^$, title:^$"
		];
	};
}