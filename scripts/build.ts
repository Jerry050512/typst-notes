import path from "path";
import { spawnSync } from "child_process";
import { listCourses, sortCourses } from "./lib/courses";
import {
  generateWrapper,
  generateWholeCourseWrapper,
  renderBookTyp,
  renderIntroTyp,
  resetWebDir,
} from "./lib/render";
import { ensureSourceHanFonts, getFontPaths } from "./lib/fonts";
import { emptyDir } from "./lib/utils";

const ROOT = process.cwd();
const WEB_DIR = path.join(ROOT, "web-notes");
const DIST_DIR = path.join(ROOT, "dist");
const ARCHIVE_DIR = path.join(ROOT, "archive");

const SHIROA_BIN = process.env.SHIROA_BIN ?? path.join(ROOT, "tools", "shiroa", "shiroa.exe");

function main() {
  console.log("[build] scanning courses...");
  const active = listCourses(ROOT).filter((c) => c.name !== "archive").sort(sortCourses);
  const archived = listCourses(ARCHIVE_DIR).sort(sortCourses);

  console.log(`[build] found ${active.length} active + ${archived.length} archived courses`);

  console.log("[build] generating web wrappers...");
  resetWebDir();
  for (const c of [...active, ...archived]) {
    for (const ch of c.chapters) generateWrapper(c, ch);
    generateWholeCourseWrapper(c, "note");
    generateWholeCourseWrapper(c, "practice");
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

  console.log("[build] running shiroa build...");
  const args = ["build", ".", "--mode", "static-html"];
  const result = spawnSync(SHIROA_BIN, args, {
    cwd: ROOT,
    stdio: "inherit",
    shell: false,
  });

  if (result.error) {
    console.error("[build] failed to spawn shiroa:", result.error);
    process.exit(1);
  }
  if (result.status !== 0) {
    console.error(`[build] shiroa exited with code ${result.status}`);
    process.exit(result.status ?? 1);
  }

  console.log(`[build] done. output: ${DIST_DIR}`);
}

main();
