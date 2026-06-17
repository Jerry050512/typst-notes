import { existsSync, readdirSync, statSync } from "fs";
import path from "path";
import { COURSE_TITLES, type Course, type Chapter } from "./types";
import { extractFirstHeading, slugify, toPosix } from "./utils";

export function scanCourse(dir: string): Course | null {
  const name = path.basename(dir);
  if (name.startsWith(".") || name === "template") return null;
  const title = COURSE_TITLES[name] ?? name;
  const chapters: Chapter[] = [];

  for (const f of readdirSync(dir).sort()) {
    const fp = path.join(dir, f);
    if (!statSync(fp).isFile()) continue;
    if (!/^\d+-.+\.typ$/.test(f)) continue;
    const slug = slugify(f);
    const title = extractFirstHeading(fp) ?? slug;
    chapters.push({ file: toPosix(path.relative(process.cwd(), fp)), slug, title });
  }

  const hasNote = existsSync(path.join(dir, "note.typ"));
  const hasPractice = existsSync(path.join(dir, "practice.typ"));

  if (chapters.length === 0 && !hasNote && !hasPractice) return null;

  return {
    name,
    title,
    dir: toPosix(path.relative(process.cwd(), dir)),
    chapters,
    hasNote,
    hasPractice,
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
