const imports = [Service.import("systemtray")];
const [systemtrayService, hyprland] = await Promise.all(imports);

/** @param {import("types/service/systemtray").TrayItem} item */
const systemTrayItem = (item) =>
	Widget.Button({
		child: Widget.Icon().bind("icon", item, "icon"),
		tooltipMarkup: item.bind("tooltip_markup"),
		onPrimaryClick: (_, event) => item.activate(event),
		onSecondaryClick: (_, event) => item.openMenu(event)
	});

export const systemTray = (
	monitor = {
		id: 0,
		x: 0,
		y: 0
	}
) => {
	// Only create a systemtray on the monitor at 0x0.
	// For me the is considered to be the primary monitor since it's not affected by resolutions.
	if (monitor.x !== 0 || monitor.y !== 0) return;

	return Widget.Box({
		children: systemtrayService.bind("items").as((i) => i.map(systemTrayItem))
	});
};
