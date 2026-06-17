import {
  existsSync,
  readdirSync,
  readFileSync,
  rmdirSync,
  rmSync,
  statSync,
} from "fs";
import path from "path";

export function toPosix(p: string): string {
  return p.replace(/\\/g, "/");
}

export function extractFirstHeading(filePath: string): string | null {
  if (!existsSync(filePath)) return null;
  const content = readFileSync(filePath, "utf-8").replace(/^\uFEFF/, "");
  const m = content.match(/^= +(.+)$/m);
  return m ? m[1].trim() : null;
}

export function slugify(name: string): string {
  return name.replace(/\.typ$/, "");
}

export function emptyDir(dir: string) {
  if (!existsSync(dir)) return;
  for (const entry of readdirSync(dir)) {
    const p = path.join(dir, entry);
    const s = statSync(p);
    if (s.isDirectory()) {
      emptyDir(p);
      rmdirSync(p);
    } else {
      rmSync(p);
    }
  }
}
