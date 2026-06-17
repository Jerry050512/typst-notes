import { existsSync, mkdirSync, readFileSync, writeFileSync } from "fs";
import path from "path";
import type { Course, Chapter } from "./types";
import { toPosix, emptyDir } from "./utils";

const ROOT = process.cwd();
const WEB_DIR = path.join(ROOT, "web-notes");

type FileModification = {
  file: string;
  offset: number;
  removed: string;
};

const modifications: FileModification[] = [];

export function clearModifications() {
  modifications.length = 0;
}

export function getModifications(): FileModification[] {
  return [...modifications];
}

export function restoreModifications() {
  if (modifications.length === 0) return;
  console.log("[build] restoring removed headings...");
  // 从文件末尾往前恢复，避免插入导致后续 offset 变化
  const sorted = [...modifications].sort((a, b) => b.offset - a.offset);
  for (const m of sorted) {
    const content = readFileSync(m.file, "utf-8");
    const newContent = content.slice(0, m.offset) + m.removed + content.slice(m.offset);
    writeFileSync(m.file, newContent);
    console.log(`[build] restored heading in ${path.relative(ROOT, m.file)}`);
  }
  modifications.length = 0;
}

export function resetWebDir() {
  emptyDir(WEB_DIR);
  mkdirSync(WEB_DIR, { recursive: true });
}

function escapeQuotes(s: string): string {
  return s.replace(/"/g, '\\"');
}

function wrapperName(course: Course, ch: Chapter, kind: "note" | "practice"): string {
  if (kind === "note") return `${course.name}-${ch.slug}.typ`;
  if (ch.slug === "practice") return `${course.name}-practice.typ`;
  return `${course.name}-practice-${ch.slug}.typ`;
}

function removeFirstHeading(filePath: string): void {
  if (!existsSync(filePath)) return;
  const content = readFileSync(filePath, "utf-8");
  const match = content.match(/^= +.+$/m);
  if (!match || match.index === undefined) return;

  const offset = match.index;
  let end = offset + match[0].length;
  if (content.charAt(end) === "\r") end++;
  if (content.charAt(end) === "\n") end++;
  const removed = content.slice(offset, end);
  const newContent = content.slice(0, offset) + content.slice(end);

  writeFileSync(filePath, newContent);
  modifications.push({ file: filePath, offset, removed });
  console.log(`[build] removed first heading from ${path.relative(ROOT, filePath)}`);
}

export function generateWrapper(course: Course, ch: Chapter, kind: "note" | "practice"): string {
  const name = wrapperName(course, ch, kind);
  const wrapperPath = path.join(WEB_DIR, name);
  const relSrc = toPosix(path.relative(WEB_DIR, path.join(ROOT, ch.file)));

  if (ch.fromInclude) {
    removeFirstHeading(path.join(ROOT, ch.file));
  }

  const content = `#import "/book.typ": book-page

#show: book-page.with(title: "${escapeQuotes(ch.title)}")

#include "${relSrc}"
`;
  writeFileSync(wrapperPath, content);
  return name;
}

function renderSummary(active: Course[], archived: Course[]): string {
  const lines: string[] = [];
  for (const c of [...active, ...archived]) {
    lines.push(`= ${c.title}`);
    for (const ch of c.noteChapters) {
      const wrapper = wrapperName(c, ch, "note");
      lines.push(`- #chapter("web-notes/${wrapper}")[${ch.title}]`);
    }
    for (const ch of c.practiceChapters) {
      const wrapper = wrapperName(c, ch, "practice");
      lines.push(`- #chapter("web-notes/${wrapper}")[${ch.title}]`);
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
