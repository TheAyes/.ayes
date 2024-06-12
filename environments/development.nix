{ pkgs ? (import <nixpkgs> {
    config.allowUnfree = true;
    config.segger-jlink.acceptLicense = true;
}), ... }: pkgs.mkShell {


	nativeBuildInputs = with pkgs; [
		nodePackages_latest.nodejs
		nodePackages_latest.pnpm
		bun
		typescript
		jetbrains.idea-ultimate
		jetbrains.rider
	];
}