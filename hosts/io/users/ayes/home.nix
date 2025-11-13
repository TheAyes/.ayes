{
  pkgs,
  lib,
  system,
  inputs,
  ...
}:
{
  imports = [
    ../../../../common/users/ayes/home.nix

    ./hyprland.nix
    ./nixcord.nix
    ./kitty.nix
  ];

  home = {
    packages = with pkgs; [
      # Gaming
      xivlauncher
      (prismlauncher.override {
        jdks = [
          graalvmPackages.graalvm-ce
          temurin-jre-bin
          zulu17
        ];
      })
      ed-odyssey-materials-helper

      heroic
      lutris

      # Music Production
      bitwig-studio

      zed-editor

      #jetbrains.webstorm
      #jetbrains.pycharm-professional
      #jetbrains.idea-ultimate
      #jetbrains.rider
      #jetbrains.rust-rover

      godot-mono

      #rustup
      nodejs
      bun
      uv
      ruff
      claude-code
      nil
      nixd

      dotnetCorePackages.dotnet_9.sdk

      blockbench
      gimp
      proton-pass
    ];

  };

  programs = {
    bitwig = {
      enable = true;
      extraPackages = with pkgs; [
        yabridge
        yabridgectl

        # VST's
        vital
      ];
    };

    zen-browser = {
      enable = true;
      package = inputs.zen-browser.packages."${system}".twilight;
      profiles = {
        ayes = {
          id = 0;
          name = "ayes";
          isDefault = true;
          extensions = {
            force = true;
            packages = with inputs.firefox-addons.packages.${system}; [
              ublock-origin
              darkreader
              #betterttv # Can't install due to unfree
              proton-pass
              proton-vpn
              decentraleyes
            ];
          };
          settings = {
            "app.update.auto" = false;

            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true;
            "privacy.webrtc.legacyGlobalIndicator" = false;
            "widget.use-xdg-desktop-portal.file-picker" = 1;
            "zen.view.sidebar-expanded" = false;
            "zen.watermark.enabled" = false;
            "zen.welcome-screen.seen" = true;
          };
          pinsForce = true;
          pins =
            let
              utils = import ../../../../modules/nixos/utils.nix { inherit lib; };
            in
            {
              music = {
                title = "Music";
                id = utils.generateUUID "music";
                url = "https://music.youtube.com/";
                isEssential = true;
                position = 1000;
              };
              youtube = {
                title = "Youtube";
                id = utils.generateUUID "youtube";
                url = "https://youtube.com/";
                isEssential = true;
                position = 2000;
              };
              email = {
                title = "E-Mail";
                id = utils.generateUUID "email";
                url = "https://mail.proton.me/";
                isEssential = true;
                position = 3000;
              };
              nixos_packages = {
                title = "NixOS Packages";
                id = utils.generateUUID "nixospackages";
                url = "https://search.nixos.org/packages?channel=unstable";
                isEssential = false;
                position = 10000;
              };
              hm_options = {
                title = utils.generateUUID "hmoptions";
                id = "ee18f999-cb14-4b81-9f1b-b7a03dc4ba89";
                url = "https://home-manager-options.extranix.com/?query=&release=master";
                isEssential = false;
                position = 11000;
              };
            };
        };
      };

      policies =
        let
          mkExtensionSettings = builtins.mapAttrs (
            _: pluginId: {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
              installation_mode = "force_installed";
            }
          );
        in
        {
          ExtensionSettings = mkExtensionSettings {
            #"addon@darkreader.org" = "darkreader"; # Installed via Nur
            #"78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass"; # Installed via Nur
            #"vpn@proton.ch" = "proton-vpn-firefox-extension"; # Installed via Nur
            "firefox@betterttv.net" = "betterttv";
            "{8454caa8-cebc-4486-8b23-9771f187ed6c}" = "600-sound-volume-privacy";
            #"uBlock0@raymondhill.net" = "ublock-origin"; # Installed via Nur
            "idcac-pub@guus.ninja" = "istilldontcareaboutcookies";
          };
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          GenerativeAI = {
            Enabled = false;
            Chatbot = false;
            LinkPreviews = false;
            TabGroups = false;
            Locked = false;
          };
        };
    };
  };

  xdg = {
    enable = true;

    cacheHome = /mnt/games/cache/ayes;
    desktopEntries = {
      noitaEntangledWorlds = {
        type = "Application";
        genericName = "noita-proxy";
        name = "Noita Entangled Worlds";
        icon = ../../../../assets/images/noita-proxy.png;
        exec = "sh -c \"steam-run /mnt/games/noita_entangled_worlds/noita_proxy.x86_64\"";
      };
    };
  };

  gtk.gtk2.enable = false;
}
