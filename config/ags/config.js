import { workspaces } from "./widgets/workspaces.js";

const systemtray = await Service.import("systemtray");

/** @param {import("types/service/systemtray").TrayItem} item */
const SysTrayItem = (item) =>
	Widget.Button({
		child: Widget.Icon().bind("icon", item, "icon"),
		tooltipMarkup: item.bind("tooltip_markup"),
		onPrimaryClick: (_, event) => item.activate(event),
		onSecondaryClick: (_, event) => item.openMenu(event)
	});

const sysTray = Widget.Box({
	children: systemtray.bind("items").as((i) => i.map(SysTrayItem))
});

const hyprland = await Service.import("hyprland");

const focusedTitle = Widget.Label({
	label: hyprland.active.client.bind("title"),
	visible: hyprland.active.client.bind("address").as((addr) => !!addr)
});
const makeBar = (monitor = 0) => {
	const label = Widget.Label({
		label: "date"
	});

	Utils.interval(1000, async () => {
		label.label = await Utils.execAsync("date");
	});

	const bar = Widget.Window({
		monitor,
		exclusivity: "exclusive",
		name: `bar${monitor}`,
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
				children: [workspaces(monitor)]
			}),
			endWidget: Widget.Box({
				hpack: "end",
				children: [sysTray]
			})
		})
	});

	return bar;
};
const scss = "/home/ayes/.nixos/config/ags/style.scss";
const css = "/home/ayes/.nixos/config/ags/out/style.css";
Utils.exec(`sassc ${scss} ${css}`);

App.config({
	windows: [makeBar(0), makeBar(1), makeBar(2)],
	style: css
});
