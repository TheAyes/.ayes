{ config, pkgs, inputs, lib, ... }: {
	imports = [
		./config/vesktop.nix
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
			bitwig-studio
			pcmanfm
			hyprland-workspaces
			xarchiver
			hyprshot
			lutris
			inputs.hyprsome.packages.x86_64-linux.default
			#xorg.xhost
			#gpu-screen-recorder-gtk
			xdg-desktop-portal-hyprland
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
		eww = {
			enable = true;
			package = pkgs.eww;
			configDir = ./config/eww;
		};

		waybar = {
			enable = false;
			systemd.enable = true;
			package = pkgs.waybar;
			settings = {
				mainBar = {
					layer = "top";
					position = "top";
					height = 30;
					modules-left = [];
					modules-center = [];
					module-right = [
						"clock"
					];
				};
				clock = {
					format = "{%H:%M:%S %d/%m%y}";
					
				};
			};
			
		};
		
		eza = {
			enable = true;
			enableFishIntegration = true;
			package = pkgs.eza;
			git = true;
			icons = true;
		};

		firefox = {
			enable = true;
			package = pkgs.firefox;
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
