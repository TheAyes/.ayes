export const notificationService = await Service.import("notifications");

notificationService.popupTimeout = 3000;
notificationService.forceTimeout = false;
notificationService.cacheActions = false;
notificationService.clearDelay = 100;

/** @param {import("resource:///com/github/Aylur/ags/service/notifications.js").Notification} notifyEvent */
const Notification = (notifyEvent) => {
	const icon = Widget.Box({
		vpack: "start",
		class_name: "icon",
		child: NotificationIcon(notifyEvent)
	});

	const title = Widget.Label({
		class_name: "title",
		xalign: 0,
		justification: "left",
		hexpand: true,
		max_width_chars: 24,
		truncate: "end",
		wrap: true,
		label: notifyEvent.summary,
		use_markup: true
	});

	const body = Widget.Label({
		class_name: "body",
		hexpand: true,
		use_markup: true,
		xalign: 0,
		justification: "left",
		label: notifyEvent.body,
		wrap: true
	});

	const actions = Widget.Box({
		class_name: "actions",
		children: notifyEvent.actions.map(({ id, label }) =>
			Widget.Button({
				class_name: "action-button",
				on_clicked: () => {
					notifyEvent.invoke(id);
					notifyEvent.dismiss();
				},
				hexpand: true,
				child: Widget.Label(label)
			})
		)
	});

	return Widget.EventBox(
		{
			attribute: { id: notifyEvent.id },
			on_primary_click: notifyEvent.dismiss
		},
		Widget.Box(
			{
				class_name: `notification ${notifyEvent.urgency}`,
				vertical: true
			},
			Widget.Box([icon, Widget.Box({ vertical: true }, title, body)]),
			actions
		)
	);
};

export function NotificationPopups(monitor = 0) {
	const list = Widget.Box({
		vertical: true,
		children: notificationService.popups.map(Notification)
	});

	function onNotified(_, /** @type {number} */ id) {
		const notifyEvent = notificationService.getNotification(id);
		if (notifyEvent) list.children = [Notification(notifyEvent), ...list.children];
	}

	function onDismissed(_, /** @type {number} */ id) {
		list.children.find((notifyEvent) => notifyEvent.attribute.id === id)?.destroy();
	}

	list.hook(notificationService, onNotified, "notified").hook(notificationService, onDismissed, "dismissed");

	return Widget.Window({
		monitor,
		name: `notifications${monitor}`,
		class_name: "notification-popups",
		anchor: ["top", "right"],
		child: Widget.Box({
			css: "min-width: 2px; min-height: 2px;",
			class_name: "notifications",
			vertical: true,
			child: list

			/** this is a simple one liner that could be used instead of
                hooking into the 'notified' and 'dismissed' signals.
                but its not very optimized becuase it will recreate
                the whole list everytime a notification is added or dismissed */
			// children: notifications.bind('popups')
			//     .as(popups => popups.map(Notification))
		})
	});
}
