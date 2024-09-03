import { MprisPlayer } from "../../types/service/mpris";
import Label from "../../types/widgets/label";

const MAX_LENGTH = 50;

const mprisService = await Service.import("mpris");

export const playerWidgets = mprisService.bind("players").as((p) =>
	p.map((player: MprisPlayer) => {
		return Widget.Box({
			class_name: "musicPlayer",
			children: [
				Widget.Box({
					children: [
						Widget.Label({ class_name: "musicLabel" }).hook(player, (label: Label<any>) => {
							const { track_artists, track_title } = player;
							const filteredTrackArtists = track_artists.filter(
								(currentArtist) => currentArtist.length > 0
							);

							const artists =
								filteredTrackArtists.length > 0
									? `${filteredTrackArtists.join(", ")} plays `
									: "Currently playing ";
							label.label = (artists + track_title).slice(0, MAX_LENGTH);
						})
					]
				}),
				Widget.Box({
					children: [
						Widget.Button({
							sensitive: !player.can_go_prev,
							classNames: ["musicPlayerButton", player.can_go_prev ? "" : "musicPlayerButton-inactive"],
							onClicked: () => {
								if (player.can_go_prev) player.previous().then();
							},
							child: Widget.Label({ label: "" })
						}),
						Widget.Button({
							classNames: ["musicPlayerButton"],
							onClicked: () => player.playPause(),
							child: Widget.Label().hook(player, (label: Label<any>) => {
								switch (player.play_back_status) {
									case "Playing":
										label.label = "";
										break;
									case "Paused":
										label.label = "";
										break;
									case "Stopped":
										label.label = "";
										break;
								}
							})
						}),
						Widget.Button({
							sensitive: !player.can_go_next,
							classNames: ["musicPlayerButton", player.can_go_next ? "" : "musicPlayerButton-inactive"],
							onClicked: () => {
								if (player.can_go_next) player.next().then();
							},

							child: Widget.Label({ label: "" })
						})
					]
				})
			]
		});
	})
);

export const makePlayerWidget = () => {
	return Widget.Box({
		children: playerWidgets
	});
};
