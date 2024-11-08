import { Monitor } from "../../../types";
import { makeDateTime } from "../dateTime/dateTime";
import { makeSystemTray } from "../systemTray";

export const makeRightBar = (monitor: Monitor) =>
	Widget.Box({
		hpack: "end",

		// Only create a systemtray on the monitor at 0x0.
		// For me the is considered to be the primary monitor since it's not affected by resolutions.
		// Previously this check has been put into the makeSystemTray() function itself.
		// This however led to an error as the property here can't handle undefined returns.
		children: (() => {
			const widgets = monitor.x === 0 && monitor.y === 0 ? [makeSystemTray()] : [];

			// @ts-ignore
			return widgets.concat([makeDateTime()]);
		})()
	});
