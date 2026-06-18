import path from "path";
import { existsSync } from "fs";
import { spawnSync } from "child_process";
import { listCourses, sortCourses } from "./lib/courses";
import {
  generateWrapper,
  renderBookTyp,
  renderIntroTyp,
  resetWebDir,
  clearModifications,
  restoreModifications,
} from "./lib/render";
import { ensureSourceHanFonts, getFontPaths } from "./lib/fonts";
import { generateSearchIndex } from "./lib/search";
import { emptyDir } from "./lib/utils";

const ROOT = process.cwd();
const DIST_DIR = path.join(ROOT, "dist");
const ARCHIVE_DIR = path.join(ROOT, "archive");

function findShiroaInPath(): string | undefined {
  const exeName = process.platform === "win32" ? "shiroa.exe" : "shiroa";
  const paths = (process.env.PATH ?? process.env.Path ?? "").split(path.delimiter);
  for (const p of paths) {
    const candidate = path.join(p, exeName);
    if (existsSync(candidate)) return candidate;
  }
  return undefined;
}

const SHIROA_BIN =
  process.env.SHIROA_BIN ??
  findShiroaInPath() ??
  path.join(ROOT, "tools", "shiroa", process.platform === "win32" ? "shiroa.exe" : "shiroa");

function normalizePathToRoot(p: string): string {
  let s = p;
  if (!s.startsWith("/")) s = "/" + s;
  if (!s.endsWith("/")) s = s + "/";
  return s;
}

function runBuild() {
  console.log("[build] scanning courses...");
  const active = listCourses(ROOT).filter((c) => c.name !== "archive").sort(sortCourses);
  const archived = listCourses(ARCHIVE_DIR).sort(sortCourses);

  console.log(`[build] found ${active.length} active + ${archived.length} archived courses`);

  console.log("[build] generating web wrappers...");
  resetWebDir();
  for (const c of [...active, ...archived]) {
    for (const ch of c.noteChapters) generateWrapper(c, ch, "note");
    for (const ch of c.practiceChapters) generateWrapper(c, ch, "practice");
  }

  console.log("[build] generating book.typ and intro.typ from templates...");
  renderBookTyp(active, archived);
  renderIntroTyp(active, archived);

  console.log("[build] cleaning dist...");
  emptyDir(DIST_DIR);

  const fontPaths = getFontPaths();
  const sourceHanDir = ensureSourceHanFonts();
  fontPaths.push(sourceHanDir);
  process.env.TYPST_FONT_PATHS = fontPaths.join(path.delimiter);
  console.log("[build] font paths:", fontPaths.join(", "));

  const basePath = normalizePathToRoot(process.env.BASE_PATH ?? "/");
  console.log("[build] path-to-root:", basePath);

  console.log("[build] running shiroa build...");
  const args = [
    "build", 
    ".", 
    "--mode", 
    "static-html", 
    "--path-to-root", 
    basePath,
    "--font-path",
    fontPaths.join(path.delimiter),
  ];
  const result = spawnSync(SHIROA_BIN, args, {
    cwd: ROOT,
    stdio: "inherit",
    shell: false,
  });

  if (result.error) {
    console.error("[build] failed to spawn shiroa:", result.error);
    throw new Error(`failed to spawn shiroa: ${result.error.message}`);
  }
  if (result.status !== 0) {
    console.error(`[build] shiroa exited with code ${result.status}`);
    throw new Error(`shiroa exited with code ${result.status}`);
  }

  console.log("[build] generating search index...");
  generateSearchIndex(DIST_DIR);

  console.log(`[build] done. output: ${DIST_DIR}`);
}

function main() {
  clearModifications();
  try {
    runBuild();
  } catch (err) {
    console.error("[build] build failed:", err);
    process.exit(1);
  } finally {
    restoreModifications();
  }
}

main();
