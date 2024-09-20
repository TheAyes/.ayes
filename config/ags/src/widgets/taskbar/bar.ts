import { makeMonitor, Monitor } from "../../../types";
import { makeCenterBar } from "./centerBar";
import { makeLeftBar } from "./leftBar";
import { makeRightBar } from "./rightBar";

export const makeBar = (monitor: Monitor = makeMonitor()) => {
	return Widget.Window({
		monitor: monitor.id,
		exclusivity: "exclusive",
		name: `bar${monitor.id}`,
		anchor: ["top", "left", "right"],
		class_name: "bar",
		child: Widget.CenterBox({
			spacing: 8,
			vertical: false,
			startWidget: makeLeftBar(monitor),
			centerWidget: makeCenterBar(monitor),
			endWidget: makeRightBar(monitor)
		})
	});
};
