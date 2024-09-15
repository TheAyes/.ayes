{ config, pkgs, inputs, ... }: {
	imports = [
		./hardware-configuration.nix
	];

	hardware = {
		bluetooth = {
			enable = true;
			powerOnBoot = true;
		};

		logitech.wireless = {
			enable = true;
		};

		graphics = {
			enable = true;
			enable32Bit = true;

			extraPackages = [
				pkgs.amdvlk
			];
		};
	};

	nix = {
		optimise = {
			automatic = true;
			dates= [ "06:00" ];
		};
		settings = {
			experimental-features = [
				"nix-command"
				"flakes"
			];
		};

		gc = {
			automatic = true;
			dates = "daily";
			options = "--delete-older-than 7d";
		};
	};

	# Bootloader
	boot = {
		kernelPackages = pkgs.linuxPackages_zen;
		#kernelPackages = pkgs.linuxPackages;

		kernelModules = [
			"amdgpu"
		];

		kernelParams = [
			"video=DP-1:1920x1080@60"
			"video=DP-2:1920x1080@60"
			"video=HDMI-A-1:1920x1080@60"
		];

		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};

		initrd.systemd.dbus.enable = true;
	};

	systemd = {
		services = {
			lact = {
				description = "AMDGPU Control Daemon";
				enable = true;
				serviceConfig = {
					ExecStart = "${pkgs.lact}/bin/lact daemon";
				};
				wantedBy = ["multi-user.target"];
			};
		};

		user.services = {
			polkit-kde-authentication-agent-1 = {
				enable = true;
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

			steam = {
				enable = true;
				description = "Open Steam in the background at boot";
				wantedBy = [ "graphical-session.target" ];
				startLimitIntervalSec = 1800;
				startLimitBurst = 5;
				serviceConfig = {
					ExecStart = "${pkgs.steam}/bin/steam -nochatui -nofriendui -silent %U";
					Restart = "on-failure";
					RestartSec = "5s";

				};
			};

			solaar = {
				enable = true;
				description = "Open Solaar in the background at boot";
				wantedBy = [ "graphical-session.target" ];
				startLimitIntervalSec = 1800;
				startLimitBurst = 5;
				serviceConfig = {
					ExecStart = "${pkgs.solaar}/bin/solaar --window=hide";
					Restart = "on-failure";
					RestartSec = "5s";

				};
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

	security = {
		polkit.enable = true;
		rtkit.enable = true;

		pam.services.sddm.enableGnomeKeyring = true;

		wrappers = {
			gsr-kms-server = {
				owner = "root";
				group = "root";
				capabilities = "cap_sys_admin+ep";
				source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
			};
		};

		sudo = {
			enable = true;

			wheelNeedsPassword = false;
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
	users = {
		users = {
			ayes = {
				isNormalUser = true;
				description = "Ayes";
				extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
				packages = with pkgs; [

				];
			};
		};

		extraGroups.vboxusers.members = [ "ayes" ];
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
			WLR_NO_HARDWARE_CURSORS = "1";

			AMD_VULKAN_ICD = "RADV";
			#VK_ICD_FILENAMES="${pkgs.amdvlk}/share/vulkan/icd.d/radeon_icd.x86_64.json";
		};

		systemPackages = with pkgs; [
			wget
			alejandra

			libsForQt5.qtstyleplugin-kvantum
			catppuccin-sddm

			pwvucontrol
			playerctl
			wl-clipboard
			wev
			kdePackages.qtwayland
			kdePackages.polkit-kde-agent-1
			wineWow64Packages.staging

			lact
			virt-manager
			amdvlk
		];
	};

	fonts.packages = with pkgs; [
		nerdfonts
		noto-fonts
		noto-fonts-cjk
		noto-fonts-emoji
	];

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

			videoDrivers = [ "amdgpu" "vmware" ];
		};

		gnome.gnome-keyring.enable = true;

		ratbagd.enable = true;

		openssh.enable = true;

		gvfs.enable = true;
	};

	virtualisation.libvirtd.enable = true;

	xdg.portal = {
		enable = true;
	};

	programs = {
		hyprland = {
			enable = true;
		};

		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;

			gamescopeSession.enable = true;
		};

		gnupg.agent = {
		  enable = true;
		  enableSSHSupport = true;
		};
		dconf.enable = true;

	};

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
