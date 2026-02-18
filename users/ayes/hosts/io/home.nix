{ pkgs
, lib
, inputs
, system
, ...
}:
{
  imports = [
    # Development Profiles
    ../../../../profiles/home-manager/development/node.nix
    ../../../../profiles/home-manager/development/python.nix
    ../../../../profiles/home-manager/development/nix.nix

    # Program Profiles
    ../../../../profiles/home-manager/programs/jetbrains.nix

    # Gaming Profiles
    ../../../../profiles/home-manager/gaming/launchers.nix
  ];

  home = {
    packages = with pkgs; [
      zed-editor

      # Gaming
      xivlauncher

      # Music Production
      bitwig-studio

      godot-mono

      claude-code

      dotnetCorePackages.dotnet_9.sdk

      blockbench
      gimp
      proton-pass
      element-desktop

      quodlibet
      haruna
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
          # search = {
          #   force = false;
          #   default = "Kagi";

          #   engines = {
          #     google.metaData.hidden = true;
          #     bing.metaData.hidden = true;
          #     ddg.metaData.hidden = true;
          #     ecosia.metaData.hidden = true;
          #     perplexity.metaData.hidden = true;
          #     wikipedia.metaData.hidden = true;

          #     nixrepo = {
          #       name = "Nixpkgs Issues & PR's";
          #       urls = [
          #         {
          #           template = "https://github.com/NixOS/nixpkgs/issues/";
          #           params = [
          #             {
          #               name = "q";
          #               value = "{searchTerms}";
          #             }
          #           ];
          #         }
          #       ];
          #       definedAliases = [ "@nr" ];
          #       iconMapObj."16" = "https://github.com/favicon.ico";
          #     };

          #     nix = {
          #       name = "NixOS/HM Packages & Options";
          #       urls = [
          #         {
          #           template = "https://searchix.ovh/";
          #           params = [
          #             {
          #               name = "query";
          #               value = "{searchTerms}";
          #             }
          #           ];
          #         }
          #       ];

          #       definedAliases = [ "@np" ];
          #       icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          #     };
          #   };
          # };

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
          ExtensionSettings = {
            "*" = {
              installation_mode = "blocked";
              blocked_install_message = "Install Extensions using your NixOS Configuration!";
            };
          }
          // mkExtensionSettings {
            "addon@darkreader.org" = "darkreader";
            "78272b6fa58f4a1abaac99321d503a20@proton.me" = "proton-pass";
            "vpn@proton.ch" = "proton-vpn-firefox-extension";
            "firefox@betterttv.net" = "betterttv";
            "{8454caa8-cebc-4486-8b23-9771f187ed6c}" = "600-sound-volume-privacy";
            "uBlock0@raymondhill.net" = "ublock-origin";
            "idcac-pub@guus.ninja" = "istilldontcareaboutcookies";
            "search@kagi.com" = "kagi-search-for-firefox";
            "{0d7cafdd-501c-49ca-8ebb-e3341caaa55e}" = "youtube-nonstop";
            "{2662ff67-b302-4363-95f3-b050218bd72c}" = "untrap-for-youtube";
            "jid1-BoFifL9Vbdl2zQ@jetpack" = "decentraleyes";
            "{6c00218c-707a-4977-84cf-36df1cef310f}" = "port-authority";
            "sponsorBlocker@ajay.app" = "sponsorblock";
          };
          AppAutoUpdate = false; # Disable automatic application update
          BackgroundAppUpdate = false; # Disable automatic application update in the background, when the application is not running.
          DisableBuiltinPDFViewer = true; # Considered a security liability
          DisableFirefoxStudies = true;
          DisableFirefoxAccounts = true; # Disable Firefox Sync
          DisableFirefoxScreenshots = true; # No screenshots?
          DisableForgetButton = true; # Thing that can wipe history for X time, handled differently
          DisableMasterPasswordCreation = true; # To be determined how to handle master password
          DisableProfileImport = true; # Purity enforcement: Only allow nix-defined profiles
          DisableProfileRefresh = true; # Disable the Refresh Firefox button on about:support and support.mozilla.org
          DisableSetDesktopBackground = true; # Remove the “Set As Desktop Background…” menuitem when right clicking on an image, because Nix is the only thing that can manage the backgroud
          DisplayMenuBar = "default-off";
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFormHistory = true;
          DisablePasswordReveal = true;
          DontCheckDefaultBrowser = true; # Stop being attention whore
          HardwareAcceleration = false; # Disabled as it exposes points for fingerprinting
          OfferToSaveLogins = false; # Managed by ProtonPass
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
            EmailTracking = true;
            # Exceptions = ["https://example.com"]
          };
          EncryptedMediaExtensions = {
            Enabled = true;
            Locked = true;
          };
          ExtensionUpdate = false;

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

    desktopEntries = { };
    #cacheHome = /mnt/games/cache/ayes;
  };
}
