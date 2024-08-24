import { Monitor } from "../types";
import Window from "../types/widgets/window";
import { makeBar } from "./widgets/bar.js";
import { Media } from "./widgets/musicPlayer";
import { makeNotifications } from "./widgets/notification";

const scss = "/home/ayes/.nixos/config/ags/style.scss";
const css = "/home/ayes/.nixos/config/ags/out/style.css";
Utils.exec(
	`sassc ${scss} ${css}`,
	(stdout) => console.log(stdout),
	(stderr) => console.error(stderr)
);

const monitors = JSON.parse(Utils.exec(`hyprctl monitors -j`)) as Monitor[];

const makeMonitorHandler = (forMonitor: number) => (operations: (...args: any[]) => Window<any, any>) => {};

const operationsPerMonitor = [
	{ monitorId: 0, operations: [makeBar(monitors[0]), makeNotifications(monitors[0]), Media()] },
	{ monitorId: 1, operations: [makeBar(monitors[1])] },
	{
		monitorId: 2,
		operations: [makeBar(monitors[2])]
	}
];

Utils.timeout(100, () =>
	Utils.notify({
		summary: "Notification Popup Example",
		iconName: "info-symbolic",
		body:
			"Lorem ipsum dolor sit amet, qui minim labore adipisicing " +
			"minim sint cillum sint consectetur cupidatat.",
		actions: {
			Cool: () => print("pressed Cool")
		},
		urgency: "low"
	})
);

App.config({
	windows: (() => {
		return operationsPerMonitor.reduce((accumulator, currentValue) => {
			return accumulator.concat(currentValue.operations);
		}, [] as any[]);
	})(),
	style: css
});
