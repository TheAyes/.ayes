export type Workspace = {
	id: number;
	name: string;
};

export type Monitor = {
	id?: number;
	name?: string;
	description?: string;
	make?: string;
	model?: string;
	serial?: string;
	width?: number;
	height?: number;
	refreshRate?: number;
	x?: number;
	y?: number;
	activeWorkspace?: Workspace;
	specialWorkspace?: Workspace;
	reserved?: number[];
	scale?: number;
	transform?: number;
	focused?: boolean;
	dpmsStatus?: boolean;
	vrr?: boolean;
	activelyTearing?: boolean;
	disabled?: boolean;
	currentFormat?: string;
	availableModes?: string[];
};

export function makeMonitor(partialMonitor: Partial<Monitor> = {}): Monitor {
	// Define your default values here
	const defaults: Monitor = {
		id: 0,
		name: "",
		description: "",
		make: "",
		model: "",
		serial: "",
		width: 0,
		height: 0,
		refreshRate: 0,
		x: 0,
		y: 0,
		activeWorkspace: { id: 1, name: "1" },
		specialWorkspace: { id: 0, name: "" },
		reserved: [],
		scale: 0,
		transform: 0,
		focused: false,
		dpmsStatus: false,
		vrr: false,
		activelyTearing: false,
		disabled: false,
		currentFormat: "",
		availableModes: []
	};

	return { ...defaults, ...partialMonitor };
}
