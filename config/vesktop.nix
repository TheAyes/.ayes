{
	xdg.configFile = {
		"vesktop/settings.json" = {
			enable = true;
			text = ''{
				"discordBranch": "stable",
				"arpc": "on",
				"splashColor": "rgb(219, 222, 225)",
				"splashBackground": "rgb(49, 51, 56)",
				"splashTheming": true
			}'';
			target = "vesktop/settings.json";
		};
		"vesktop/themes/catppuccin-mocha.css" = {
			enable = true;
			text = ''
				/**
                 * @name Catppuccin Mocha
                 * @author winston#0001
                 * @authorId 505490445468696576
                 * @version 0.2.0
                 * @description 🎮 Soothing pastel theme for Discord
                 * @website https://github.com/catppuccin/discord
                 * @invite r6Mdz5dpFc
                 * **/

                @import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");
			'';
		};
		"vesktop/settings/quickCss.css" = {
			enable = true;
			text = ''
				:root {
                    --background-primary: #1e1e2e30;
                	--background-secondary: #18182570;
                	--background-secondary-alt: #14141f70;
                	--background-tertiary: #11111b70;
                	--background-accent: #89b4fa;
                	--background-floating: #0d0d15;
                	--background-nested-floating: #181825;
                	--background-mobile-primary: #1e1e2e;
                	--background-mobile-secondary: #181825;
                }
			'';
		};
		"vesktop/settings/settings.json" = {
			enable = true;
			text = ''{
			    "autoUpdate": true,
			    "autoUpdateNotification": true,
			    "useQuickCss": true,
			    "themeLinks": [],
			    "enabledThemes": [
			        "catppuccin-mocha.css"
			    ],
			    "enableReactDevtools": false,
			    "frameless": false,
			    "transparent": true,
			    "winCtrlQ": false,
			    "disableMinSize": true,
			    "winNativeTitleBar": false,
			    "plugins": {
			    	"YoutubeAdblock": {
			    		"enabled": true
					},
			        "BadgeAPI": {
			            "enabled": true
			        },
			        "ChatInputButtonAPI": {
			            "enabled": true
			        },
			        "CommandsAPI": {
			            "enabled": true
			        },
			        "ContextMenuAPI": {
			            "enabled": true
			        },
			        "MemberListDecoratorsAPI": {
			            "enabled": false
			        },
			        "MessageAccessoriesAPI": {
			            "enabled": false
			        },
			        "MessageDecorationsAPI": {
			            "enabled": false
			        },
			        "MessageEventsAPI": {
			            "enabled": true
			        },
			        "MessagePopoverAPI": {
			            "enabled": false
			        },
			        "NoticesAPI": {
			            "enabled": true
			        },
			        "ServerListAPI": {
			            "enabled": true
			        },
			        "NoTrack": {
			            "enabled": true
			        },
			        "Settings": {
			            "enabled": true,
			            "settingsLocation": "aboveActivity"
			        },
			        "SupportHelper": {
			            "enabled": true
			        },
			        "AlwaysAnimate": {
			            "enabled": true
			        },
			        "AlwaysTrust": {
			            "enabled": false
			        },
			        "AnonymiseFileNames": {
			            "enabled": true,
			            "anonymiseByDefault": true,
			            "method": 0,
			            "randomisedLength": 7
			        },
			        "WebRichPresence (arRPC)": {
			            "enabled": false
			        },
			        "BANger": {
			            "enabled": false
			        },
			        "BetterFolders": {
			            "enabled": false
			        },
			        "BetterGifAltText": {
			            "enabled": true
			        },
			        "BetterGifPicker": {
			            "enabled": false
			        },
			        "BetterNotesBox": {
			            "enabled": false
			        },
			        "BetterRoleContext": {
			            "enabled": false
			        },
			        "BetterRoleDot": {
			            "enabled": false
			        },
			        "BetterSessions": {
			            "enabled": true,
			            "backgroundCheck": false
			        },
			        "BetterSettings": {
			            "enabled": true,
			            "disableFade": true,
			            "eagerLoad": true
			        },
			        "BetterUploadButton": {
			            "enabled": false
			        },
			        "BiggerStreamPreview": {
			            "enabled": false
			        },
			        "BlurNSFW": {
			            "enabled": false
			        },
			        "CallTimer": {
			            "enabled": false
			        },
			        "ClearURLs": {
			            "enabled": false
			        },
			        "ClientTheme": {
			            "enabled": false
			        },
			        "ColorSighted": {
			            "enabled": false
			        },
			        "ConsoleShortcuts": {
			            "enabled": false
			        },
			        "CopyUserURLs": {
			            "enabled": false
			        },
			        "CrashHandler": {
			            "enabled": true
			        },
			        "CustomRPC": {
			            "enabled": false
			        },
			        "Dearrow": {
			            "enabled": false
			        },
			        "Decor": {
			            "enabled": false
			        },
			        "DisableCallIdle": {
			            "enabled": true
			        },
			        "EmoteCloner": {
			            "enabled": false
			        },
			        "Experiments": {
			            "enabled": false
			        },
			        "F8Break": {
			            "enabled": false
			        },
			        "FakeNitro": {
			            "enabled": false
			        },
			        "FakeProfileThemes": {
			            "enabled": false
			        },
			        "FavoriteEmojiFirst": {
			            "enabled": false
			        },
			        "FavoriteGifSearch": {
			            "enabled": false
			        },
			        "FixCodeblockGap": {
			            "enabled": true
			        },
			        "FixSpotifyEmbeds": {
			            "enabled": true
			        },
			        "FixYoutubeEmbeds": {
			            "enabled": true
			        },
			        "ForceOwnerCrown": {
			            "enabled": false
			        },
			        "FriendInvites": {
			            "enabled": false
			        },
			        "FriendsSince": {
			            "enabled": false
			        },
			        "GameActivityToggle": {
			            "enabled": false
			        },
			        "GifPaste": {
			            "enabled": false
			        },
			        "GreetStickerPicker": {
			            "enabled": false
			        },
			        "HideAttachments": {
			            "enabled": false
			        },
			        "iLoveSpam": {
			            "enabled": false
			        },
			        "IgnoreActivities": {
			            "enabled": false
			        },
			        "ImageZoom": {
			            "enabled": false
			        },
			        "ImplicitRelationships": {
			            "enabled": false
			        },
			        "InvisibleChat": {
			            "enabled": false
			        },
			        "KeepCurrentChannel": {
			            "enabled": false
			        },
			        "LastFMRichPresence": {
			            "enabled": false
			        },
			        "LoadingQuotes": {
			            "enabled": false
			        },
			        "MemberCount": {
			            "enabled": false
			        },
			        "MessageClickActions": {
			            "enabled": false
			        },
			        "MessageLinkEmbeds": {
			            "enabled": false
			        },
			        "MessageLogger": {
			            "enabled": true
			        },
			        "MessageTags": {
			            "enabled": false
			        },
			        "MoreCommands": {
			            "enabled": false
			        },
			        "MoreKaomoji": {
			            "enabled": false
			        },
			        "MoreUserTags": {
			            "enabled": false
			        },
			        "Moyai": {
			            "enabled": false
			        },
			        "MutualGroupDMs": {
			            "enabled": false
			        },
			        "NewGuildSettings": {
			            "enabled": false
			        },
			        "NoBlockedMessages": {
			            "enabled": false
			        },
			        "NoDevtoolsWarning": {
			            "enabled": false
			        },
			        "NoF1": {
			            "enabled": false
			        },
			        "NoMosaic": {
			            "enabled": false
			        },
			        "NoPendingCount": {
			            "enabled": true,
			            "hideFriendRequestsCount": true,
			            "hideMessageRequestsCount": true,
			            "hidePremiumOffersCount": true
			        },
			        "NoProfileThemes": {
			            "enabled": true
			        },
			        "NoReplyMention": {
			            "enabled": false
			        },
			        "NoScreensharePreview": {
			            "enabled": true
			        },
			        "NoTypingAnimation": {
			            "enabled": false
			        },
			        "NoUnblockToJump": {
			            "enabled": true
			        },
			        "NormalizeMessageLinks": {
			            "enabled": true
			        },
			        "NotificationVolume": {
			            "enabled": true,
			            "notificationVolume": 75.17605633802818
			        },
			        "NSFWGateBypass": {
			            "enabled": false
			        },
			        "OnePingPerDM": {
			            "enabled": true,
			            "channelToAffect": "both_dms",
			            "allowMentions": false,
			            "allowEveryone": false
			        },
			        "oneko": {
			            "enabled": false
			        },
			        "OpenInApp": {
			            "enabled": true,
			            "spotify": true
			        },
			        "OverrideForumDefaults": {
			            "enabled": false
			        },
			        "Party mode 🎉": {
			            "enabled": false
			        },
			        "PermissionFreeWill": {
			            "enabled": true,
			            "lockout": true,
			            "onboarding": true
			        },
			        "PermissionsViewer": {
			            "enabled": true,
			            "permissionsSortOrder": 0,
			            "defaultPermissionsDropdownState": false
			        },
			        "petpet": {
			            "enabled": false
			        },
			        "PictureInPicture": {
			            "enabled": false
			        },
			        "PinDMs": {
			            "enabled": true,
			            "dmSectioncollapsed": false,
			            "pinOrder": 0
			        },
			        "PlainFolderIcon": {
			            "enabled": false
			        },
			        "PlatformIndicators": {
			            "enabled": false
			        },
			        "PreviewMessage": {
			            "enabled": false
			        },
			        "PronounDB": {
			            "enabled": false
			        },
			        "QuickMention": {
			            "enabled": false
			        },
			        "QuickReply": {
			            "enabled": false
			        },
			        "ReactErrorDecoder": {
			            "enabled": false
			        },
			        "ReadAllNotificationsButton": {
			            "enabled": false
			        },
			        "RelationshipNotifier": {
			            "enabled": true,
			            "offlineRemovals": true,
			            "groups": true,
			            "servers": true,
			            "friends": true,
			            "friendRequestCancels": true
			        },
			        "ResurrectHome": {
			            "enabled": false
			        },
			        "RevealAllSpoilers": {
			            "enabled": false
			        },
			        "ReverseImageSearch": {
			            "enabled": false
			        },
			        "ReviewDB": {
			            "enabled": false
			        },
			        "RoleColorEverywhere": {
			            "enabled": false
			        },
			        "SearchReply": {
			            "enabled": false
			        },
			        "SecretRingToneEnabler": {
			            "enabled": false
			        },
			        "SendTimestamps": {
			            "enabled": false
			        },
			        "ServerListIndicators": {
			            "enabled": true,
			            "mode": 2
			        },
			        "ServerProfile": {
			            "enabled": true
			        },
			        "ShikiCodeblocks": {
			            "enabled": false
			        },
			        "ShowAllMessageButtons": {
			            "enabled": false
			        },
			        "ShowConnections": {
			            "enabled": true,
			            "iconSpacing": 1,
			            "iconSize": 32
			        },
			        "ShowHiddenChannels": {
			            "enabled": true,
			            "hideUnreads": true,
			            "showMode": 0,
			            "defaultAllowedUsersAndRolesDropdownState": true
			        },
			        "ShowHiddenThings": {
			            "enabled": true,
			            "showTimeouts": true,
			            "showInvitesPaused": true
			        },
			        "ShowMeYourName": {
			            "enabled": true,
			            "displayNames": false,
			            "mode": "nick-user",
			            "inReplies": false
			        },
			        "SilentMessageToggle": {
			            "enabled": true,
			            "persistState": true,
			            "autoDisable": false
			        },
			        "SilentTyping": {
			            "enabled": true,
			            "isEnabled": true,
			            "showIcon": false
			        },
			        "SortFriendRequests": {
			            "enabled": true,
			            "showDates": false
			        },
			        "SpotifyControls": {
			            "enabled": true,
			            "hoverControls": false
			        },
			        "SpotifyCrack": {
			            "enabled": true,
			            "noSpotifyAutoPause": true,
			            "keepSpotifyActivityOnIdle": false
			        },
			        "SpotifyShareCommands": {
			            "enabled": false
			        },
			        "StartupTimings": {
			            "enabled": false
			        },
			        "StreamerModeOnStream": {
			            "enabled": false
			        },
			        "SuperReactionTweaks": {
			            "enabled": false
			        },
			        "TextReplace": {
			            "enabled": false
			        },
			        "ThemeAttributes": {
			            "enabled": false
			        },
			        "TimeBarAllActivities": {
			            "enabled": false
			        },
			        "Translate": {
			            "enabled": false
			        },
			        "TypingIndicator": {
			            "enabled": true,
			            "includeMutedChannels": false,
			            "includeCurrentChannel": true,
			            "indicatorMode": 3
			        },
			        "TypingTweaks": {
			            "enabled": false
			        },
			        "Unindent": {
			            "enabled": false
			        },
			        "UnlockedAvatarZoom": {
			            "enabled": false
			        },
			        "UnsuppressEmbeds": {
			            "enabled": false
			        },
			        "UrbanDictionary": {
			            "enabled": false
			        },
			        "UserVoiceShow": {
			            "enabled": true
			        },
			        "USRBG": {
			            "enabled": false
			        },
			        "ValidUser": {
			            "enabled": false
			        },
			        "VoiceChatDoubleClick": {
			            "enabled": false
			        },
			        "VcNarrator": {
			            "enabled": false
			        },
			        "VencordToolbox": {
			            "enabled": false
			        },
			        "ViewIcons": {
			            "enabled": false
			        },
			        "ViewRaw": {
			            "enabled": true
			        },
			        "VoiceMessages": {
			            "enabled": false
			        },
			        "WebContextMenus": {
			            "enabled": true,
			            "addBack": true
			        },
			        "WebKeybinds": {
			            "enabled": true
			        },
			        "WhoReacted": {
			            "enabled": false
			        },
			        "Wikisearch": {
			            "enabled": false
			        },
			        "XSOverlay": {
			            "enabled": false
			        }
			    },
			    "notifications": {
			        "timeout": 5000,
			        "position": "bottom-right",
			        "useNative": "not-focused",
			        "logLimit": 50
			    },
			    "cloud": {
			        "authenticated": false,
			        "url": "https://api.vencord.dev/",
			        "settingsSync": false,
			        "settingsSyncVersion": 1715318753811
			    }
			}'';
		};
	};
}
