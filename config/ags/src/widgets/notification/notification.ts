import { Monitor } from "../../../types";
import { Notification } from "../../../types/service/notifications";

export const notificationService = await Service.import("notifications");

notificationService.popupTimeout = 10000 * 1000;
notificationService.forceTimeout = false;
notificationService.cacheActions = false;
notificationService.clearDelay = 200;

const notificationIcon = ({ app_entry, app_icon, image }: Notification) => {
	if (image) {
		return Widget.Box({
			css:
				`background-image: url("${image}");` +
				"background-size: contain;" +
				"background-repeat: no-repeat;" +
				"background-position: center;"
		});
	}

	let icon = "dialog-information-symbolic";
	if (Utils.lookUpIcon(app_icon)) icon = app_icon;

	if (app_entry && Utils.lookUpIcon(app_entry)) icon = app_entry;

	return Widget.Box({
		class_name: "icon",
		child: Widget.Icon(icon)
	});
};

const notification = (n: Notification) => {
	const icon = Widget.Box({
		vpack: "start",
		class_names: ["icon"],
		child: notificationIcon(n)
	});

	const title = Widget.Label({
		class_name: "title",
		xalign: 0,
		justification: "left",
		hexpand: true,
		max_width_chars: 24,
		truncate: "end",
		wrap: true,
		label: n.summary,
		use_markup: false
	});

	const body = Widget.Label({
		class_name: "body",
		hexpand: true,
		use_markup: false,
		xalign: 0,
		justification: "left",
		label: n.body,
		wrap: true
	});

	const actions = Widget.Box({
		class_name: "actions",
		children: n.actions.map(({ id, label }) =>
			Widget.Button({
				class_name: "action-button",
				on_clicked: () => {
					n.invoke(id);
					n.dismiss();
				},
				hexpand: true,
				child: Widget.Label(label)
			})
		)
	});

	return Widget.EventBox(
		{
			attribute: { id: n.id },
			on_primary_click: n.dismiss
		},
		Widget.Box(
			{
				class_names: [`notification`, n.urgency, `active`],
				vertical: true
			},
			Widget.Box([icon, Widget.Box({ vertical: true }, title, body)]),
			actions
		)
	);
};

export const makeNotifications = (monitor: Monitor) => {
	const list = Widget.Box({
		vertical: true,
		children: notificationService.popups.map(notification)
	});

	const onNotified = (_: unknown, id: number) => {
		const n = notificationService.getNotification(id);
		if (n) {
			const w = notification(n);
			list.children = [w, ...list.children];

			let timeout: number | undefined;
			switch (n.urgency) {
				case "low":
					timeout = notificationService.popupTimeout * 0.6;
					break;

				case "normal":
					timeout = notificationService.popupTimeout;
					break;
			}

			if (timeout)
				Utils.timeout(timeout, () => {
					n.dismiss();
				});
		}
	};

	const onDismissed = (_: unknown, id: number) => {
		list.children.find((n) => n.attribute.id === id)?.destroy();
	};

	list.hook(notificationService, onNotified, "notified").hook(notificationService, onDismissed, "dismissed");

	return Widget.Window({
		monitor: monitor.id,
		name: `notifications${monitor}`,
		//class_name: "notification-popups",
		anchor: ["top", "right"],
		child: Widget.Box({
			class_name: "notifications",
			vertical: true,
			child: list
		})
	});
};
