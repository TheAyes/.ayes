const systemtray = await Service.import("systemtray");

/** @param {import("types/service/systemtray").TrayItem} item */
const SysTrayItem = item => Widget.Button({
	child: Widget.Icon().bind("icon", item, "icon"),
	tooltipMarkup: item.bind("tooltip_markup"),
	onPrimaryClick: (_, event) => item.activate(event),
	onSecondaryClick: (_, event) => item.openMenu(event)
});

const sysTray = Widget.Box({
	children: systemtray.bind("items").as(i => i.map(SysTrayItem))
});

const hyprland = await Service.import("hyprland");

const focusedTitle = Widget.Label({
	label: hyprland.active.client.bind("title"),
	visible: hyprland.active.client.bind("address")
		.as(addr => !!addr)
});

const dispatch = ws => hyprland.messageAsync(`dispatch workspace ${ws}`);

const Workspaces = () => Widget.EventBox({
	onScrollUp: () => dispatch("+1"),
	onScrollDown: () => dispatch("-1"),
	child: Widget.Box({
		children: Array.from({length: 10}, (_, i) => i + 1).map(i => Widget.Button({
			attribute: i,
			label: `${i}`,
			onClicked: () => dispatch(i)
		})),

		// remove this setup hook if you want fixed number of buttons
		setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
			btn.visible = true;//hyprland.workspaces.some(ws => ws.id === btn.attribute);
		}))
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
			hexpand: true,
			centerWidget: Workspaces(),
			endWidget: sysTray
		})
	});

	return bar;
};

App.config({
	windows: [makeBar(0), makeBar(1), makeBar(2)]
});
