{ pkgs, ... }: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
      package = pkgs.discord-canary;

      vencord.enable = true;
    };

    vesktop.enable = true;

    config = {
      useQuickCss = true; # use out quickCSS
      themeLinks = [
        # or use an online theme
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
        "https://raw.githubusercontent.com/UserPFP/UserPFP/main/import.css"
      ];
      frameless = false; # set some Vencord options
      transparent = true;
      disableMinSize = true;

      plugins = {
        alwaysAnimate.enable = true;
        betterSessions = {
          enable = true;
          backgroundCheck = true;
        };
        betterSettings.enable = false; # This plugin causes discord to break
        betterUploadButton.enable = true;
        biggerStreamPreview.enable = true;
        clearURLs.enable = true;
        consoleJanitor.enable = true;
        dearrow.enable = true;
        decor.enable = true;
        disableCallIdle.enable = true;
        emoteCloner.enable = true;
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
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        loadingQuotes.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        moreUserTags.enable = true;
        mutualGroupDMs.enable = true;
        newGuildSettings.enable = true;
        noMosaic.enable = true;
        noOnboardingDelay.enable = true;
        noPendingCount.enable = true;
        noProfileThemes.enable = true;
        #noScreensharePreview.enable = true;
        onePingPerDM.enable = true;
        permissionFreeWill.enable = true;
        pinDMs.enable = true;
        relationshipNotifier.enable = true;
        showHiddenChannels.enable = true;
        showHiddenThings.enable = true;
        showTimeoutDuration.enable = true;
        sortFriendRequests.enable = true;
        spotifyCrack.enable = true;
        superReactionTweaks.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        unlockedAvatarZoom.enable = true;
        unsuppressEmbeds.enable = true;
        USRBG.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        viewIcons.enable = true;
        volumeBooster.enable = true;
        youtubeAdblock.enable = true;

        # Vesktop specific
        webKeybinds.enable = false;
        webRichPresence.enable = false;
        webScreenShareFixes.enable = false;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };

}
