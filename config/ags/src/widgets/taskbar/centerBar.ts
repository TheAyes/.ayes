import { Monitor } from "../../../types";
import { workspaces } from "../workspaces";

export const makeCenterBar = (monitor: Monitor) =>
	Widget.Box({
		hpack: "center",
		class_name: "workspaces",
		children: [workspaces(monitor)]
	});
