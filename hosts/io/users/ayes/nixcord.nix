{ pkgs, ... }: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = true;
      package = pkgs.discord-canary;

      vencord.enable = true;
    };

    vesktop.enable = false;

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
        friendsSince.enable = true;
        fullSearchContext.enable = true;
        loadingQuotes.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        #moreUserTags.enable = true;
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
        #favouriteEmojiFirst.enable = true;
        #silentTyping.enable = true;

        # Vesktop specific
        webKeybinds.enable = true;
        webRichPresence.enable = false;
        webScreenShareFixes.enable = true;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
    quickCss = ''
      :root {
        --custom-app-top-bar-height: 0;
      }

      li.channel__972a0.container_e45859:has(div a[href="/store"]),
      li.channel__972a0.container_e45859:has(div a[href="/shop"]),
      div.buttons__74017 div[aria-label="Send a gift"],
      div.buttons__74017 div:has(div[aria-label="Send a gift"]),
      .mask__0d616,
      div.bar_c38106 {
        display: none
      }

      div.itemsContainer_ef3116 {
        padding-block: 8px;
      }
    '';
  };

}
