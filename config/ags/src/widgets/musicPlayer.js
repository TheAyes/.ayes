const mpris = await Service.import("mpris");

const Player = (player) => {
	const widget = Widget.Button({
		onClicked: () => player.playPause(),
		child: Widget.Label().hook(player, (label) => {
			const { track_artists, track_title } = player;
			label.label = `${track_artists.join(", ")} - ${track_title}`;
		})
	});
	return widget;
};

export const players = mpris.bind("players").as((p) => p.map(Player));
