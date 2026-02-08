{ pkgs, lib, ... }:
{
  programs.nixcord = {
    enable = true;
    discord = {
      #enable = true;
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
        ClearURLs.enable = true;
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
        MutualGroupDMs.enable = true;
        newGuildSettings.enable = true;
        noMosaic.enable = true;
        noOnboardingDelay.enable = true;
        noPendingCount.enable = true;
        noProfileThemes.enable = true;
        #noScreensharePreview.enable = true;
        OnePingPerDM.enable = true;
        permissionFreeWill.enable = true;
        PinDMs.enable = true;
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
        USRBG = {
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

}
