import { Monitor } from "../types";
import { makeNotifications } from "./widgets/notification/notification";
import { makeBar } from "./widgets/taskbar/bar.js";

const scss = "/home/ayes/.nixos/config/ags/style.scss";
const css = "/home/ayes/.nixos/config/ags/out/style.css";
Utils.exec(
	`sassc ${scss} ${css}`,
	() => {},
	(stderr) => console.error(stderr)
);

const monitors = JSON.parse(Utils.exec(`hyprctl monitors -j`)) as Monitor[];

// Todo: Handle cases where certain monitor id's do not exist
const operationsPerMonitor = [
	{
		monitorId: 0,
		operations: [makeBar(monitors[0]), makeNotifications(monitors[0])]
	},
	{ monitorId: 1, operations: [makeBar(monitors[1])] },
	{
		monitorId: 2,
		operations: [makeBar(monitors[2])]
	}
];

const filteredOperations = operationsPerMonitor.filter((item) => {
	return monitors.some((monitor) => monitor.id === item.monitorId);
});

App.config({
	windows: (() => {
		return filteredOperations.reduce((accumulator, currentValue) => {
			return accumulator.concat(currentValue.operations);
		}, [] as any[]);
	})(),
	style: css
});
