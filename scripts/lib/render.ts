import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import path from "path";
import type { Course, Chapter } from "./types";
import { toPosix, emptyDir } from "./utils";

const ROOT = process.cwd();
const WEB_DIR = path.join(ROOT, "web-notes");

export function resetWebDir() {
  emptyDir(WEB_DIR);
  mkdirSync(WEB_DIR, { recursive: true });
}

function escapeQuotes(s: string): string {
  return s.replace(/"/g, '\\"');
}

export function generateWrapper(course: Course, ch: Chapter): string {
  const wrapperName = `${course.name}-${ch.slug}.typ`;
  const wrapperPath = path.join(WEB_DIR, wrapperName);
  const relSrc = toPosix(path.relative(WEB_DIR, path.join(ROOT, ch.file)));
  const content = `#import "/book.typ": book-page

#show: book-page.with(title: "${escapeQuotes(ch.title)}")

#include "${relSrc}"
`;
  writeFileSync(wrapperPath, content);
  return wrapperName;
}

export function generateWholeCourseWrapper(
  course: Course,
  kind: "note" | "practice",
): string | null {
  const src = path.join(course.dir, `${kind}.typ`);
  if (!existsSync(path.join(ROOT, src))) return null;
  const wrapperName = `${course.name}-${kind}.typ`;
  const wrapperPath = path.join(WEB_DIR, wrapperName);
  const relSrc = toPosix(path.relative(WEB_DIR, path.join(ROOT, src)));
  const title = kind === "note" ? `${course.title}（笔记）` : `${course.title}（练习）`;
  const content = `#import "/book.typ": book-page

#show: book-page.with(title: "${escapeQuotes(title)}")

#include "${relSrc}"
`;
  writeFileSync(wrapperPath, content);
  return wrapperName;
}

function renderSummary(active: Course[], archived: Course[]): string {
  const lines: string[] = [];
  for (const c of [...active, ...archived]) {
    lines.push(`= ${c.title}`);
    for (const ch of c.chapters) {
      const wrapper = `${c.name}-${ch.slug}.typ`;
      lines.push(`- #chapter("web-notes/${wrapper}")[${ch.title}]`);
    }
    if (c.hasNote) {
      lines.push(`- #chapter("web-notes/${c.name}-note.typ")[${c.title}（全篇）]`);
    }
    if (c.hasPractice) {
      lines.push(`- #chapter("web-notes/${c.name}-practice.typ")[${c.title}（练习）]`);
    }
  }
  return lines.map((l) => "    " + l).join("\n");
}

export function renderBookTyp(active: Course[], archived: Course[]) {
  const template = readFileSync(path.join(ROOT, "book.template.typ"), "utf-8");
  const summary = renderSummary(active, archived);
  const bookTyp = template.replace("{{ BookSummary }}", summary);
  writeFileSync(path.join(ROOT, "book.typ"), bookTyp);
}

function renderCourseList(active: Course[], archived: Course[]): string {
  return [...active, ...archived].map((c) => `- ${c.title}`).join("\n");
}

export function renderIntroTyp(active: Course[], archived: Course[]) {
  const template = readFileSync(path.join(ROOT, "intro.template.typ"), "utf-8");
  const list = renderCourseList(active, archived);
  const introTyp = template.replace("{{ CourseList }}", list);
  writeFileSync(path.join(ROOT, "intro.typ"), introTyp);
}
