import { Monitor } from "../types";
import { makeBar } from "./widgets/bar.js";

const scss = "/home/ayes/.nixos/config/ags/style.scss";
const css = "/home/ayes/.nixos/config/ags/out/style.css";
Utils.exec(`sassc ${scss} ${css}`);

const monitors = JSON.parse(Utils.exec(`hyprctl monitors -j`)) as Monitor[];

App.config({
	windows: monitors.map((monitor) => makeBar(monitor)),
	style: css
});
