import { existsSync, readFileSync, readdirSync, statSync } from "fs";
import path from "path";
import { COURSE_TITLES, type Course, type Chapter } from "./types";
import { extractFirstHeading, slugify, toPosix } from "./utils";

const ROOT = process.cwd();

function parseIncludes(filePath: string): string[] | null {
  if (!existsSync(filePath)) return null;
  const content = readFileSync(filePath, "utf-8").replace(/^\uFEFF/, "");
  const includes: string[] = [];
  const regex = /^#include\s+"(.+?)"\s*$/gm;
  let m: RegExpExecArray | null;
  while ((m = regex.exec(content)) !== null) {
    includes.push(m[1]);
  }
  return includes.length > 0 ? includes : null;
}

function makeChapterFromFile(courseDir: string, relPath: string, fromInclude: boolean): Chapter | null {
  const fp = path.resolve(courseDir, relPath);
  if (!existsSync(fp)) return null;
  const slug = slugify(path.basename(fp));
  const title = extractFirstHeading(fp) ?? slug;
  return {
    file: toPosix(path.relative(ROOT, fp)),
    slug,
    title,
    fromInclude,
  };
}

function collectChapters(courseDir: string, kind: "note" | "practice", courseTitle: string): Chapter[] {
  const mainFile = path.join(courseDir, `${kind}.typ`);
  if (!existsSync(mainFile)) return [];

  const includes = parseIncludes(mainFile);
  if (includes) {
    const chapters: Chapter[] = [];
    for (const inc of includes) {
      const ch = makeChapterFromFile(courseDir, inc, true);
      if (ch) chapters.push(ch);
    }
    return chapters;
  }

  // 没有 include 其他文件，整体渲染
  const slug = kind;
  const title = kind === "note" ? `${courseTitle}（全篇）` : `${courseTitle}（练习）`;
  return [
    {
      file: toPosix(path.relative(ROOT, mainFile)),
      slug,
      title,
      fromInclude: false,
    },
  ];
}

export function scanCourse(dir: string): Course | null {
  const name = path.basename(dir);
  if (name.startsWith(".") || name === "template") return null;
  const title = COURSE_TITLES[name] ?? name;

  const noteChapters = collectChapters(dir, "note", title);
  const practiceChapters = collectChapters(dir, "practice", title);

  if (noteChapters.length === 0 && practiceChapters.length === 0) return null;

  return {
    name,
    title,
    dir: toPosix(path.relative(ROOT, dir)),
    noteChapters,
    practiceChapters,
  };
}

export function listCourses(parent: string): Course[] {
  const courses: Course[] = [];
  if (!existsSync(parent)) return courses;
  for (const d of readdirSync(parent)) {
    const dp = path.join(parent, d);
    if (!statSync(dp).isDirectory()) continue;
    const c = scanCourse(dp);
    if (c) courses.push(c);
  }
  return courses;
}

export function sortCourses(a: Course, b: Course): number {
  const order = Object.keys(COURSE_TITLES);
  const ia = order.indexOf(a.name);
  const ib = order.indexOf(b.name);
  if (ia !== -1 && ib !== -1) return ia - ib;
  if (ia !== -1) return -1;
  if (ib !== -1) return 1;
  return a.name.localeCompare(b.name);
}
