export const makeDateTime = () => {
	const dateLabel = Widget.Label({
		className: "date",
		label: "date",
		hpack: "start"
	});

	const timeLabel = Widget.Label({
		className: "date",
		label: "time",
		hpack: "start"
	});

	const dotLabel = Widget.Label({
		className: "date",
		label: "•",
		hpack: "start",
		"width-chars": 2
	});

	const progress = Widget.LevelBar({
		value: 0,
		maxValue: 100,
		minValue: 0
	});

	Utils.interval(1000, async () => {
		const dateTime = new Date();

		dateLabel.label = dateTime.toLocaleString("de-DE", {
			day: "2-digit",
			month: "2-digit",
			year: "2-digit"
		});

		timeLabel.label = dateTime.toLocaleString("de-DE", {
			hour12: false,
			hour: "2-digit",
			minute: "2-digit"
		});

		dotLabel.label = dateTime.getSeconds() % 2 === 0 ? "•" : "";

		progress.value = Math.floor((dateTime.getSeconds() / 59) * progress.maxValue);
	});

	return Widget.Box({
		className: "dateTime",
		vertical: true,
		children: [
			Widget.Box({
				children: [timeLabel, dotLabel, dateLabel]
			}),
			progress
		]
	});
};
