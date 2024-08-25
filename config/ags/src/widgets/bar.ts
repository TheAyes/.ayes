import { makeMonitor, Monitor } from "../../types";
import { makeDateTime } from "./dateTime";
import { playerWidget } from "./musicPlayer";
import { makeSystemTray } from "./systemTray";
import { workspaces } from "./workspaces";

const mprisService = await Service.import("mpris");

export const makeBar = (monitor: Monitor = makeMonitor()) => {
	return Widget.Window({
		monitor: monitor.id,
		exclusivity: "exclusive",
		name: `bar${monitor.id}`,
		anchor: ["top", "left", "right"],
		class_name: "bar",
		child: Widget.CenterBox({
			spacing: 8,
			vertical: false,
			startWidget: Widget.Box({
				hpack: "start",
				spacing: 8,
				children: [
					makeDateTime(),
					Widget.Box({ children: mprisService.bind("players").as((p) => p.map(playerWidget)) })
				]
			}),
			centerWidget: Widget.Box({
				hpack: "center",
				class_name: "workspaces",
				children: [workspaces(monitor)]
			}),
			endWidget: Widget.Box({
				hpack: "end",

				// Only create a systemtray on the monitor at 0x0.
				// For me the is considered to be the primary monitor since it's not affected by resolutions.
				// Previously this check has been put into the makeSystemTray() function itself.
				// This however led to an error as the property here can't handle undefined returns.
				children: monitor.x !== 0 || monitor.y !== 0 ? [] : [makeSystemTray()]
			})
		})
	});
};
