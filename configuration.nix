# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
	imports = [
		./hardware-configuration.nix
		#<home-manager/nixos>
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

			package = let 
				rcu_patch = pkgs.fetchpatch {
					url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
					hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
				};
			in config.boot.kernelPackages.nvidiaPackages.mkDriver {
				version = "535.154.05";
				sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
				sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
				openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
				settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
				persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
		
				#version = "550.40.07";
				#sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
				#sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
				#openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
				#settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
				#persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";
		
				patches = [ rcu_patch ];
		    };
		};

		opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};
	};

	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	# Bootloader
	boot = {
		kernelPackages = pkgs.linuxPackages_zen;

		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};
	#boot.loader.systemd-boot.enable = true;
	#boot.loader.efi.canTouchEfiVariables = true;

	#boot.kernelPackages = pkgs.linuxPackages_zen;
	
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

	########## Locales ##########

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
			packages = with pkgs; [];
		};
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		wget
		kitty
		alejandra
		pavucontrol
		playerctl
		git
		xwayland
		wl-clipboard
		wev
	];

	services = {
		displayManager.sddm.enable = true;
		gnome.gnome-keyring.enable = true;
		
  		resolved = {
	    	enable = true;
	    	dnssec = "true";
	    	domains = ["~."];
	    	fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
	    	dnsovertls = "true";
		};

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
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };
	programs = {
		hyprland.enable = true;
		steam = {
			enable = true;
			remotePlay.openFirewall = true;
			dedicatedServer.openFirewall = true;
		};
		fish.enable = true;
	};
	
	programs.bash = {
	  interactiveShellInit = ''
	    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
	    then
	      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
	      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
	    fi
	  '';
	};

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
