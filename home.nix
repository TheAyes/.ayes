{ config, pkgs, inputs, lib, ... }: {
	imports = [
		./config/vesktop.nix
		inputs.ags.homeManagerModules.default
	];

	home = {
		username = "ayes";
		homeDirectory = lib.mkForce "/home/ayes";
		stateVersion = "23.11";

		packages = with pkgs; [
			btop
			micro
			vesktop
			prismlauncher
			#jetbrains-toolbox
			jetbrains.idea-ultimate
			jetbrains.rider
			bitwig-studio
			pcmanfm
			hyprland-workspaces
			xarchiver
			hyprshot
			lutris
			inputs.hyprsome.packages.x86_64-linux.default
			#gpu-screen-recorder
			#gpu-screen-recorder-gtk
			obs-studio
			haruna
			nomacs
			
			godot_4
		];

		file = {
			"${config.xdg.configHome}/micro/colorschemes" = {
				source = ./config/micro/colorschemes;
				recursive = true;
			};
		};

		pointerCursor = {
			package = pkgs.rose-pine-cursor;
			name = "BreezeX-RosePineDawn-Linux";
			size = 24;
	
			gtk.enable = true;
			x11.enable = true;
		};
	};

	fonts.fontconfig.enable = true;

	
	gtk = {
		enable = true;
		theme = {
			package = pkgs.rose-pine-gtk-theme;
			name = "rose-pine";
		};
		
		iconTheme = {
			package = pkgs.rose-pine-icon-theme;
			name = "rose-pine";
		};
	};

	qt = {
		enable = true;
		style = {
			name = "kvantum";
		};
	};

	programs = {
		ags = {
			enable = true;
			configDir = ./config/ags;
			extraPackages = with pkgs; [
				gtksourceview
				webkitgtk
				accountsservice
			];
		};

		direnv = {
			enable = true;
			config = {

			};
		};

		kitty = {
			enable = true;

			settings = {
				shell_integration = true;
			};

			extraConfig = ''
				# vim:ft=kitty

                ## name:     Catppuccin Kitty Mocha
                ## author:   Catppuccin Org
                ## license:  MIT
                ## upstream: https://github.com/catppuccin/kitty/blob/main/themes/mocha.conf
                ## blurb:    Soothing pastel theme for the high-spirited!



                # The basic colors
                foreground              #cdd6f4
                background              #1e1e2e
                selection_foreground    #1e1e2e
                selection_background    #f5e0dc

                # Cursor colors
                cursor                  #f5e0dc
                cursor_text_color       #1e1e2e

                # URL underline color when hovering with mouse
                url_color               #f5e0dc

                # Kitty window border colors
                active_border_color     #b4befe
                inactive_border_color   #6c7086
                bell_border_color       #f9e2af

                # OS Window titlebar colors
                wayland_titlebar_color system
                macos_titlebar_color system

                # Tab bar colors
                active_tab_foreground   #11111b
                active_tab_background   #cba6f7
                inactive_tab_foreground #cdd6f4
                inactive_tab_background #181825
                tab_bar_background      #11111b

                # Colors for marks (marked text in the terminal)
                mark1_foreground #1e1e2e
                mark1_background #b4befe
                mark2_foreground #1e1e2e
                mark2_background #cba6f7
                mark3_foreground #1e1e2e
                mark3_background #74c7ec

                # The 16 terminal colors

                # black
                color0 #45475a
                color8 #585b70

                # red
                color1 #f38ba8
                color9 #f38ba8

                # green
                color2  #a6e3a1
                color10 #a6e3a1

                # yellow
                color3  #f9e2af
                color11 #f9e2af

                # blue
                color4  #89b4fa
                color12 #89b4fa

                # magenta
                color5  #f5c2e7
                color13 #f5c2e7

                # cyan
                color6  #94e2d5
                color14 #94e2d5

                # white
                color7  #bac2de
                color15 #a6adc8

                background_opacity 	0.8
				background_blur		system
			'';
		};
		
		eza = {
			enable = true;
			enableFishIntegration = true;
			package = pkgs.eza;
			git = true;
			icons = true;
		};

		librewolf = {
			enable = true;
		};

		firefox = {
			enable = true;
			#package = pkgs.librewolf;
			policies = {
				PasswordManagerEnabled = false;
				PopupBlocking = true;
				OfferToSaveLogins = false;
				HardwareAcceleration = true;

				ExtensionUpdate = true;
				ExtensionSettings = let
					extensionUrl = x: "https://addons.mozilla.org/firefox/downloads/latest/${x}/latest.xpi";
				in {
					"uBlock0@raymondhill.net" = {
						installation_mode = "force_installed";
						install_url = extensionUrl "ublock-origin";
					};
					
					"addon@darkreader.org" = {
						installation_mode = "force_installed";
						install_url = extensionUrl "darkreader";
					};

					"78272b6fa58f4a1abaac99321d503a20@proton.me" = {
						installation_mode = "force_installed";
						install_url = extensionUrl "proton-pass";
					};

					"FirefoxColor@mozilla.com" = {
						installation_mode = "force_installed";
						install_url = extensionUrl "firefox-color";
					};
				};
			};
		};

		micro = {
			enable = true;
			settings = {
				autosu = true;
				mkparents = true;
				colorscheme = "rose-pine";
			};
		};

		wofi = {
			enable = true;
			package = pkgs.wofi;
			settings = {
				prompt = "Search";
				matching = "contains";
				insensitive = true;
			};
		};

		fuzzel = {
			enable = false;
			package = pkgs.fuzzel;
			settings = {
				main = {
					terminal = "${pkgs.kitty}/bin/kitty";
					layer = "overlay";
					icon-theme = "rose-pine";
					
				};
			};
		};

		fish = {
			enable = true;
			shellAliases = {
				l = "ls -alh --color=auto";
				ll = "ls -l --color=auto";
				ls = "ls --color=auto";
				rebuild = "~/.nixos/rebuild.sh";
				upgrade = "~/.nixos/upgrade.sh";
				test-rebuild = "~/.nixos/test.sh";
			};

			functions = {
				rebuild = "/home/ayes/.nixos/rebuild.sh $argv";
				test-rebuild = "/home/ayes/.nixos/test.sh $argv";
				upgrade = "/home/ayes/.nixos/upgrade.sh $argv";

				fish_prompt = ''
					#Save the return status of the previous command
					set -l last_pipestatus $pipestatus
					set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

					if functions -q fish_is_root_user; and fish_is_root_user
						printf '%s@%s %s%s%s# ' $USER (prompt_hostname) (set -q fish_color_cwd_root
																		 and set_color $fish_color_cwd_root
																		 or set_color $fish_color_cwd) \
							(prompt_pwd) (set_color normal)
					else
						set -l status_color (set_color $fish_color_status)
						set -l statusb_color (set_color --bold $fish_color_status)
						set -l pipestatus_string (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)

						printf '[%s] %s%s@%s %s%s %s%s%s \n> ' (date "+%H:%M:%S") (set_color brblue) \
							$USER (prompt_hostname) (set_color $fish_color_cwd) $PWD $pipestatus_string \
							(set_color normal)
					end
				'';
			};
		};

		bash = {
			enable = true;
			initExtra = ''
				if [[
					$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" &&
					-z ''${BASH_EXECUTION_STRING}
				]] then
					shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
					exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
				fi
			'';
		};
	};

	services = {
		#hypridle = {
		#	enable = true;
		#	package = pkgs.hypridle;
		#};

		#hyprpaper = {
		#	enable = true;
		#	package = pkgs.hyprpaper;
		#};
	
		dunst = {
			enable = true;
			package = pkgs.dunst;
			configFile = "$XDG_CONFIG_HOME/dunst/dunstrc";
		};

		gnome-keyring = {
			enable = true;
		};
	};

	nixpkgs.config.allowUnfree = true;

	wayland = {
		windowManager.hyprland = {
			enable = true;
			settings = import ./config/hyprland.nix;
			systemd = {
				enable = true;
				enableXdgAutostart = true;
			};

			xwayland = {
				enable = true;
			};
		};
	};

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"inode/directory" = ["pcmanfm.desktop"];
			"application/pdf" = ["firefox.desktop"];

			## Videos ##
			"application/mp4" = ["haruna"];

			## Music ##
			"application/mp3" = ["haruna"];
			"application/wav" = ["haruna"];
		};
	};
}
