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

	Utils.interval(1000, async () => {
		const dateTime = new Date();

		dateLabel.label = dateTime.toLocaleString("de-DE", {
			day: "numeric",
			month: "numeric",
			year: "2-digit"
		});

		timeLabel.label = dateTime.toLocaleString("de-DE", {
			hour12: false,
			hour: "2-digit",
			minute: "2-digit"
		});

		dotLabel.label = dateTime.getSeconds() % 2 === 0 ? "•" : "";
	});

	return Widget.Box({
		className: "dateTime",
		vertical: false,
		children: [timeLabel, dotLabel, dateLabel]
	});
};
