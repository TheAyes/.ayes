import { Monitor } from "../../../types";
import { makePlayerWidget } from "../musicPlayer";

export const makeLeftBar = (monitor: Monitor) =>
	Widget.Box({
		hpack: "start",
		spacing: 8,
		children: [makePlayerWidget()]
	});
