import { MprisPlayer } from "../../types/service/mpris";
import Label from "../../types/widgets/label";

const MAX_LENGTH = 50;

const mprisService = await Service.import("mpris");

export const playerWidgets = mprisService.bind("players").as((p) =>
	p.map((player: MprisPlayer) => {
		return Widget.Box({
			class_name: "musicPlayer",
			vertical: true,
			children: [
				Widget.Box({
					children: [
						Widget.Box({
							children: [
								Widget.Label({ class_name: "musicLabel" }).hook(player, (label: Label<any>) => {
									const { track_title } = player;

									label.label = track_title.slice(0, MAX_LENGTH);
								})
							]
						}),
						Widget.Box({
							children: [
								Widget.Button({
									classNames: ["musicPlayerButton"],
									onClicked: () => player.playPause(),
									child: Widget.Label().hook(player, (label: Label<any>) => {
										switch (player.play_back_status) {
											case "Playing":
												label.label = "";
												break;

											case "Stopped":
											case "Paused":
												label.label = "";
												break;
										}
									})
								})
							]
						})
					]
				}),
				Widget.Slider({
					drawValue: false,
					onChange: ({ value }) => (player.position = value * player.length),
					visible: player.bind("length").as((l) => l > 0),
					setup: (self) => {
						const update = () => {
							const value = player.position / player.length;
							self.value = value > 0 ? value : 0;
						};

						self.hook(player, update);
						self.hook(player, update, "position");
						self.poll(1000, update);
					}
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
