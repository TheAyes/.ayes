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
			gpu-screen-recorder-gtk
			kdePackages.polkit-kde-agent-1
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
			name = "qt6gtk2";
			package = pkgs.qt6Packages.qt6gtk2;
		};
		platformTheme.name = "gtk3";
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
			config = {};
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
		};
	};
}
