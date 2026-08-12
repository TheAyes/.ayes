{
  config,
  pkgs,
  lib,
  ...
}:
let
  vesktopSettings = "${config.programs.nixcord.vesktop.configDir}/settings/settings.json";
  lastfmKeyFile = "/run/secrets/lastfm/api-key";
in
{
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
      package = pkgs.discord-canary;

      vencord.enable = false;
    };

    vesktop.enable = true;

    config = {
      disableMinSize = false;

      plugins = {
        alwaysAnimate.enable = true;
        betterSessions = {
          enable = true;
          backgroundCheck = true;
        };
        betterSettings.enable = lib.mkForce false; # This plugin causes discord to break
        betterUploadButton.enable = true;
        biggerStreamPreview.enable = true;
        clearUrls.enable = true;
        consoleJanitor.enable = true;
        dearrow.enable = true;
        decor.enable = true;
        disableCallIdle.enable = true;
        expressionCloner.enable = true;
        fakeNitro.enable = true;
        fakeProfileThemes = {
          enable = true;
          nitroFirst = false;
        };
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        forceOwnerCrown.enable = true;
        #friendsSince.enable = true;
        fullSearchContext.enable = true;
        loadingQuotes.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        # apiKey is not set here on purpose: nixcord renders this config into a
        # world-readable /nix/store JSON file. The key is injected from sops at
        # activation time instead - see the bottom of this file.
        musicRichPresence = {
          enable = true;
          username = "Ayes_XD";
          shareUsername = true;
          statusName = "";
          useListeningStatus = true;
          clickableLinks = true;
          nameFormat = "artist-first";
          scrobblerBackend = "lastfm";
          showAlbumCover = true;
          showLogo = true;
          statusDisplayType = "track";
        };
        #moreUserTags.enable = true;
        mutualGroupDms.enable = true;
        newGuildSettings.enable = true;
        noMosaic.enable = true;
        noOnboardingDelay.enable = true;
        noPendingCount.enable = true;
        noProfileThemes.enable = true;
        #noScreensharePreview.enable = true;
        onePingPerDm.enable = true;
        permissionFreeWill.enable = true;
        pinDms.enable = true;
        relationshipNotifier.enable = true;
        showHiddenChannels.enable = false;
        showHiddenThings.enable = true;
        showTimeoutDuration.enable = true;
        sortFriendRequests.enable = true;
        spotifyCrack.enable = true;
        superReactionTweaks.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        unlockedAvatarZoom.enable = true;
        unsuppressEmbeds.enable = true;
        usrbg = {
          enable = true;
          nitroFirst = false;
        };
        validReply.enable = true;
        validUser.enable = true;
        viewIcons.enable = true;
        volumeBooster.enable = true;
        youtubeAdblock.enable = true;
        #favouriteEmojiFirst.enable = true;
        #silentTyping.enable = true;

        # Vesktop specific
        #webKeybinds.enable = true;
        #webRichPresence.enable = false;
        #webScreenShareFixes.enable = true;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };

  # nixcord installs settings.json as a read-only symlink into the store. We
  # replace it with a real file that has the Last.fm key injected, so `force`
  # keeps home-manager's collision check from aborting the next activation.
  home.file.${vesktopSettings}.force = true;

  home.activation.nixcordLastfmApiKey = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    if [ -r ${lastfmKeyFile} ]; then
      umask 077
      src="$(readlink -f ${lib.escapeShellArg vesktopSettings})"
      tmp="$(mktemp)"
      if ${lib.getExe pkgs.jq} --rawfile key ${lastfmKeyFile} \
           '.plugins.MusicRichPresence.apiKey = ($key | sub("\\s+$"; ""))' \
           "$src" > "$tmp"; then
        run rm -f ${lib.escapeShellArg vesktopSettings}
        run install -m600 "$tmp" ${lib.escapeShellArg vesktopSettings}
      else
        echo "nixcord: could not inject the Last.fm API key, leaving settings.json as-is" >&2
      fi
      rm -f "$tmp"
    else
      echo "nixcord: ${lastfmKeyFile} is not readable, skipping Last.fm API key injection" >&2
    fi
  '';

}
