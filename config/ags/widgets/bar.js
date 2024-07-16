import { workspaces } from "./workspaces.js";
import { systemTray } from "./systemTray.js";

export const makeBar = (
	monitor = {
		id: 0,
		x: 0,
		y: 0
	}
) => {
	const label = Widget.Label({
		label: "date"
	});

	Utils.interval(1000, async () => {
		label.label = new Date().toLocaleDateString();
	});

	const bar = Widget.Window({
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
				children: [label]
			}),
			centerWidget: Widget.Box({
				hpack: "center",
				class_name: "workspaces",
				children: [workspaces(monitor.id)]
			}),
			endWidget: Widget.Box({
				hpack: "end",
				children: [systemTray(monitor)]
			})
		})
	});

	return bar;
};
