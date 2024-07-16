export const makeDateTime = () => {
	const date = Widget.Label({
		class_name: "date",
		label: "date",
		hpack: "start"
	});

	const time = Widget.Label({
		class_name: "time",
		label: "time",
		hpack: "start"
	});

	Utils.interval(1000, async () => {
		const dateTime = new Date();
		date.label = dateTime.toLocaleString("de-DE", {
			day: "numeric",
			month: "numeric",
			year: "2-digit"
		});
		time.label = dateTime.toLocaleString("de-DE", {
			hour12: false,
			hour: "2-digit",
			minute: "2-digit",
			second: "2-digit"
		});
	});

	return Widget.Box({
		class_name: "dateTimeBox",
		vertical: true,
		children: [time, date]
	});
};
