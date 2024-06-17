pkgs: pkgs.mkShell {
	
	packages = with pkgs; [
		nodePackages_latest.nodejs
		nodePackages_latest.pnpm
		bun
		typescript
	];
}
