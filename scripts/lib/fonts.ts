import { existsSync, mkdirSync, readdirSync, rmSync } from "fs";
import path from "path";
import { spawnSync } from "child_process";

const ROOT = process.cwd();

export function getFontPaths(): string[] {
  const candidates: string[] = [];
  const home = process.env.HOME ?? process.env.USERPROFILE;

  if (process.platform === "win32") {
    candidates.push(
      path.join(process.env.LOCALAPPDATA ?? "", "Microsoft", "Windows", "Fonts"),
      "C:/Windows/Fonts",
    );
  } else if (process.platform === "darwin") {
    candidates.push(
      "/Library/Fonts",
      "/System/Library/Fonts",
      path.join(home ?? "", "Library", "Fonts"),
    );
  } else {
    candidates.push(
      "/usr/share/fonts",
      "/usr/local/share/fonts",
      path.join(home ?? "", ".local", "share", "fonts"),
    );
  }

  return candidates.filter((p) => existsSync(p));
}

function hasOtfFiles(dir: string): boolean {
  return existsSync(dir) && readdirSync(dir).some((f) => f.toLowerCase().endsWith(".otf"));
}

function downloadAndUnzip(url: string, destDir: string, fileName: string) {
  mkdirSync(destDir, { recursive: true });
  const zipPath = path.join(destDir, fileName);

  console.log(`[build] downloading ${fileName}...`);
  if (process.platform === "win32") {
    const ok = spawnSync(
      "powershell",
      ["-Command", `Invoke-WebRequest -Uri "${url}" -OutFile "${zipPath}"`],
      { stdio: "inherit" },
    );
    if (ok.status !== 0) throw new Error(`failed to download ${url}`);
  } else {
    const ok = spawnSync("curl", ["-L", "-o", zipPath, url], { stdio: "inherit" });
    if (ok.status !== 0) throw new Error(`failed to download ${url}`);
  }

  console.log(`[build] extracting ${fileName}...`);
  if (process.platform === "win32") {
    const ok = spawnSync(
      "powershell",
      ["-Command", `Expand-Archive -Path "${zipPath}" -DestinationPath "${destDir}" -Force`],
      { stdio: "inherit" },
    );
    if (ok.status !== 0) throw new Error(`failed to extract ${zipPath}`);
  } else {
    const ok = spawnSync("unzip", ["-o", "-q", zipPath, "-d", destDir], { stdio: "inherit" });
    if (ok.status !== 0) throw new Error(`failed to extract ${zipPath}`);
  }

  rmSync(zipPath);
}

export function ensureSourceHanFonts(): string {
  const baseDir = path.join(ROOT, "tools", "fonts", "source-han-serif");
  const cnDir = path.join(baseDir, "SubsetOTF", "CN");
  const twDir = path.join(baseDir, "SubsetOTF", "TW");

  if (!hasOtfFiles(cnDir)) {
    downloadAndUnzip(
      "https://github.com/adobe-fonts/source-han-serif/releases/download/2.003R/14_SourceHanSerifCN.zip",
      baseDir,
      "source-han-serif-cn.zip",
    );
  }
  if (!hasOtfFiles(twDir)) {
    downloadAndUnzip(
      "https://github.com/adobe-fonts/source-han-serif/releases/download/2.003R/15_SourceHanSerifTW.zip",
      baseDir,
      "source-han-serif-tw.zip",
    );
  }

  return baseDir;
}
