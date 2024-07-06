{ config, pkgs, inputs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	hardware = {
		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};

		nvidia = {
			open = false;
			nvidiaSettings = true;
			modesetting.enable = true;
			
			powerManagement = {
				enable = false;
				finegrained = false;
			};

			package = config.boot.kernelPackages.nvidiaPackages.beta;
		};

		logitech.wireless = {
			enable = true;
		};


		graphics.enable = true;

	};

	nix = {
		settings = {
			auto-optimise-store = true;
			experimental-features = [
				"nix-command"
				"flakes"
			];
		};
	};

	# Bootloader
	boot = {
		kernelPackages = pkgs.linuxPackages_zen;
		#kernelPackages = pkgs.linuxPackages;
		kernelParams = [
			"nvidia_drm.fbdev=1"
		];

		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};

	systemd.user.services = {
		polkit-kde-authentication-agent-1 = {
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};
	
	########## Networking ##########

  	networking = {
  		hostName = "io";
  		
  		wireless = {
  			userControlled.enable = true;
			iwd = {
				enable = true;
				settings = {
					IPv6.enabled = true;
					Settings.Autoconnect = true;
					Settings.AlwaysRandomizeAddress = true;
				};
			};
		};

  		nameservers = [ "8.8.8.8" "1.1.1.1" ];

  		firewall = {
  			enable = true;
  			#allowedTCPPorts = [];
  			#allowedUDPPorts = [];
  		};
  	};

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	#networking.firewall.enable = true;

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	# networking.networkmanager.enable = true;

	security = {
		polkit.enable = true;
		rtkit.enable = true;

		sudo = {
			enable = true;
			extraRules = [{
				commands = [
					{
						command = "/home/ayes/.nixos/test.sh";
						options = [ "NOPASSWD" ];
					}
				];
				groups = [ "wheel" ];
			}];
		};

		wrappers = {
			gsr-kms-server = {
				owner = "root";
				group = "root";
				capabilities = "cap_sys_admin+ep";
				source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
			};
		};
	};

	########## Locales ##########;

	# Set your time zone.
	time.timeZone = "Europe/Berlin";

	# Select internationalisation properties.
	i18n = {
		defaultLocale = "en_US.UTF-8";
		extraLocaleSettings = {
			LC_ADDRESS = "de_DE.UTF-8";
			LC_IDENTIFICATION = "de_DE.UTF-8";
			LC_MEASUREMENT = "de_DE.UTF-8";
			LC_MONETARY = "de_DE.UTF-8";
			LC_NAME = "de_DE.UTF-8";
			LC_NUMERIC = "de_DE.UTF-8";
			LC_PAPER = "de_DE.UTF-8";
			LC_TELEPHONE = "de_DE.UTF-8";
			LC_TIME = "de_DE.UTF-8";
		};
	};
	
	# Configure console keymap
	console.keyMap = "de-latin1-nodeadkeys";

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users = {
		ayes = {
			isNormalUser = true;
			description = "Ayes";
			extraGroups = [ "wheel" "networkmanager" ];
			packages = with pkgs; [

			];
		};
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment = {
		variables = {
			NIXOS_OZONE_WL = "1";
			XCURSOR_SIZE = "24";
			HYPRCURSOR_SIZE = "24";

			QT_QPA_PLATFORM="wayland";
			QT_QPA_PLATFORMTHEME = "qt6ct";

			XDG_SESSION_TYPE = "wayland";
			LIBVA_DRIVER_NAME = "nvidia";
			__GLX_VENDOR_LIBRARY_NAME = "nvidia";
			GBM_BACKEND = "nvidia-drm";
			NVD_BACKEND = "direct";
			WLR_NO_HARDWARE_CURSORS = "1";
		};

		systemPackages = with pkgs; [
			wget
			alejandra

			libsForQt5.qtstyleplugin-kvantum
			catppuccin-sddm

			pavucontrol
			playerctl
			git
			git-credential-manager
			wl-clipboard
			wev
			kdePackages.qtwayland
			kdePackages.polkit-kde-agent-1
			wineWowPackages.staging
			gnome-keyring
		];
	};

	services = {
		displayManager.sddm = {
			enable = true;
			wayland.enable = true;
			package = pkgs.kdePackages.sddm;

			theme = "catppuccin-mocha";
		};
		
  		resolved = {
	    	enable = true;
	    	dnssec = "true";
	    	domains = ["~."];
	    	fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
	    	dnsovertls = "true";
		};

		flatpak.enable = true;

		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};

		blueman.enable = true;

		xserver = {
			enable = true;
			xkb.layout = "de";
			xkb.variant = "nodeadkeys";

			videoDrivers = [ "nvidia" ];
		};
	};

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	xdg.portal.enable = true;

	programs = {
		hyprland = {
			enable = true;
			portalPackage = pkgs.xdg-desktop-portal-hyprland;
		};

		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
		};

		#fish = {
		#	enable = true;
		#	shellAliases = {
		#		l = "ls -alh --color=auto";
		#		ll = "ls -l --color=auto";
		#		ls = "ls --color=auto";
		#		rebuild = "~/.nixos/rebuild.sh";
		#		upgrade = "~/.nixos/upgrade.sh";
		#		test-rebuild = "~/.nixos/test.sh";
		#	};
		#
		#	interactiveShellInit = ''
		#		direnv hook fish | source
		#		set -g direnv_fish_mode eval_on_arrow
		#	'';
		#};

		gnupg.agent = {
		  enable = true;
		  enableSSHSupport = true;
		};
	};
	
	#programs.bash = {
	#  interactiveShellInit = ''
	#    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
	#    then
	#      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
	#      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
	#    fi
	#  '';
	#};

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;
	

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
