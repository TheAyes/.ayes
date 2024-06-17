const makeBar = (monitor = 0) => {
	const label = Widget.Label({
		label: "date"
	});

	Utils.interval(1000, async () => {
		label.label = await Utils.execAsync("date");
	});

	return Widget.Window({
		monitor,
		exclusivity: "exclusive",
		name: `bar${monitor}`,
		anchor: ["top", "left", "right"],
		child: Widget.Label().poll(1000, async (label) => (label.label = await Utils.execAsync("date")))
	});
};

App.config({
	windows: [makeBar(0), makeBar(1), makeBar(2)]
});
