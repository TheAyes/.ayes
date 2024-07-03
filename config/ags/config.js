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

const Workspaces = () =>
	Widget.EventBox({
		child: Widget.Box({
			children: Array.from({ length: 9 }, (_, i) => i + 1).map((i) =>
				Widget.Button({
					attribute: i,
					label: `${i}`,
					onClicked: () => Utils.exec(`hyprsome workspace ${i}`)
				})
			)
		})
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
		child: Widget.CenterBox({
			spacing: 8,
			vertical: false,
			startWidget: Widget.Box({
				hpack: "start",
				child: label
			}),
			centerWidget: Widget.Box({
				hpack: "center",
				child: Workspaces(monitor)
			}),
			endWidget: Widget.Box({
				hpack: "end",
				child: sysTray
			})
		})
	});

	return bar;
};

App.config({
	windows: [makeBar(0), makeBar(1), makeBar(2)]
});
