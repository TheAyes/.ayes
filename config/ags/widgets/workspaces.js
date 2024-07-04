const hyprland = await Service.import("hyprland");

export const workspaces = (monitor) =>
	Widget.Box({
		children: Array.from({ length: 9 }, (_, i) => i + 1).map((i) =>
			Widget.Button({
				attribute: i,
				label: ``,
				class_name: "workspace_btn",
				onClicked: () => Utils.exec(`hyprsome workspace ${i}`),
				setup: (self) =>
					self.hook(hyprland, () => {
						self.toggleClassName("active", hyprland.active.workspace.id === Number(`${monitor}${i}`));
						self.toggleClassName(
							"occupied",
							(hyprland.getWorkspace(Number(`${monitor}${i}`))?.windows ?? 0) > 0
						);
					})
			})
		)
	});
