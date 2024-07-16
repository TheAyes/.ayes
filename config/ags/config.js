const entry = "/home/ayes/.nixos/config/ags/src/main.ts";
const outdir = "/home/ayes/.nixos/config/ags/out/";

try {
	await Utils.execAsync([
		"bun",
		"build",
		entry,
		"--outdir",
		outdir,
		"--external",
		"resource://*",
		"--external",
		"gi://*"
	]);
	await import(`file://${outdir}/main.js`);
} catch (error) {
	console.error(error);
}
