import { MprisPlayer } from "../../types/service/mpris";
import Label from "../../types/widgets/label";

export const playerWidget = (player: MprisPlayer) => {
	return Widget.Button({
		class_name: "musicPlayer",
		onClicked: () => player.playPause(),
		child: Widget.Label({ class_name: "musicLabel" }).hook(player, (label: Label<any>) => {
			const { track_artists, track_title } = player;
			const filteredTrackArtists = track_artists.filter((currentArtist) => currentArtist.length > 0);

			const artists =
				filteredTrackArtists.length > 0 ? `${filteredTrackArtists.join(", ")} plays ` : "Currently playing ";
			label.label = artists + track_title;
		})
	});
};
