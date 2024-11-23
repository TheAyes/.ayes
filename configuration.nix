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
        /*pkgs.amdvlk*/
      ];
    };

    amdgpu = {
      initrd.enable = true;
    };
  };

  nix = {
    optimise = {
      automatic = true;
      dates = [ "06:00" ];
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
      options = "--delete-older-than 30d";
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
        wantedBy = [ "multi-user.target" ];
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
        extraGroups = [ "wheel" "networkmanager" "libvirtd" "docker" ];
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

      QT_QPA_PLATFORM = "wayland";

      XDG_RUNTIME_DIR = "/run/user/$UID";
      XDG_SESSION_TYPE = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";

      AMD_VULKAN_ICD = "RADV";
    };

    systemPackages = with pkgs; [
      libsForQt5.qtstyleplugin-kvantum

      pavucontrol
      playerctl
      wl-clipboard
      wl-clip-persist
      wev
      kdePackages.qtwayland
      kdePackages.qtsvg
      kdePackages.qt6ct
      libsForQt5.qt5ct
      kdePackages.polkit-kde-agent-1
      wineWowPackages.stagingFull
      catppuccin-sddm
      lact
      virt-manager
    ];
  };

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  stylix = {
    enable = true;
    polarity = "dark";

    image = ./config/hypr/wallpapers/dark_anime_wallpaper.jpg;

    cursor = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
      size = 24;
    };

    fonts = {
      sizes = {
        applications = 10;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };

      monospace = {
        name = "FiraCode Nerd Font Propo";
        package = pkgs.fira-code-nerdfont;
      };

      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };

      serif = {
        name = "DejaVu Serif";
        package = pkgs.dejavu_fonts;
      };


      emoji = {
        name = "Noto Emoji";
        package = pkgs.noto-fonts-emoji;
      };
    };

    base16Scheme = {
      base00 = "1e1e2e"; # base
      base01 = "181825"; # mantle
      base02 = "313244"; # surface0
      base03 = "45475a"; # surface1
      base04 = "585b70"; # surface2
      base05 = "cdd6f4"; # text
      base06 = "f5e0dc"; # rosewater
      base07 = "b4befe"; # lavender
      base08 = "f38ba8"; # red
      base09 = "fab387"; # peach
      base0A = "f9e2af"; # yellow
      base0B = "a6e3a1"; # green
      base0C = "94e2d5"; # teal
      base0D = "89b4fa"; # blue
      base0E = "cba6f7"; # mauve
      base0F = "f2cdcd"; # flamingo
    };

    targets = {
      gtk.enable = true;
    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [

      ];

      settings = {
        General = {
          DefaultSession = "hyprland.desktop";
        };
      };

      theme = "catppuccin-mocha";
    };

    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
      dnsovertls = "true";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    blueman.enable = true;

    udev = {
      enable = true;
      extraRules = ''
        				ATTRS{name}=="Sony Computer Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        				ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        			'';
    };

    xserver = {
      enable = true;
      xkb.layout = "de";
      xkb.variant = "nodeadkeys";


      videoDrivers = [ "vmware" ];
    };

    gnome.gnome-keyring.enable = true;
    ratbagd.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  xdg = {
    mime.enable = true;
    menus.enable = true;
    portal = {
      enable = true;
    };
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
