import Service from "../../types/service";
import { Application } from "../../types/service/applications";
import Window from "../../types/widgets/window";

export const applicationService = await Service.import("applications");

export const makeAppLauncher = async ({ width: number = 500, height: number = 500, spacing: number = 12 }) => {
	const activeMonitorString = await Utils.execAsync("hyprctl activeworkspace -j");
	const activeMonitor = JSON.parse(activeMonitorString) as {
		id: number;
		name: string;
		monitor: string;
		monitorID: number;
		windows: number;
		hasfullscreen: boolean;
		lastwindow: string;
		lastwindowtitle: string;
	};

	const application = (app: Application) => {
		return Widget.Box({
			children: [
				Widget.Icon({
					size: 42,
					icon: app.icon_name ?? ""
				}),
				Widget.Label({
					class_name: "title",
					label: app.name,
					xalign: 0,
					vpack: "center",
					truncate: "end"
				})
			]
		});
	};

	return Widget.Window({
		name: "APPLICATION_LAUNCHER",
		monitor: activeMonitor.monitorID,
		anchor: [],
		layer: "top",
		child: Widget.Box({
			children: applicationService.list.map(application)
		}),
		setup: (self: Window<any, any>) => {
			self.keybind("Escape", () => {
				App.closeWindow(self.name ?? "APPLICATION_LAUNCHER");
			});
		}
	});
};
