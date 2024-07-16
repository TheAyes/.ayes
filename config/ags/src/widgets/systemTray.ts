const imports = [Service.import("systemtray")];
const [systemtrayService, hyprland] = await Promise.all(imports);

const systemTrayItem = (item) =>
	Widget.Button({
		child: Widget.Icon().bind("icon", item, "icon"),
		tooltipMarkup: item.bind("tooltip_markup"),
		onPrimaryClick: (_, event) => item.activate(event),
		onSecondaryClick: (_, event) => item.openMenu(event)
	});

export const makeSystemTray = () => {
	return Widget.Box({
		children: systemtrayService.bind("items").as((i) => i.map(systemTrayItem))
	});
};
