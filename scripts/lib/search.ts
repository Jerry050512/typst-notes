import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import path from "path";

export interface SearchDoc {
  url: string;
  title: string;
  body: string;
}

function isHtml(file: string): boolean {
  return file.endsWith(".html");
}

function walk(dir: string, files: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = path.join(dir, entry);
    const st = statSync(full);
    if (st.isDirectory()) {
      walk(full, files);
    } else if (st.isFile() && isHtml(entry)) {
      files.push(full);
    }
  }
  return files;
}

function extractTitle(html: string): string {
  const m = html.match(/<title[^>]*>([\s\S]*?)<\/title>/i);
  if (m) {
    return stripTags(m[1]).trim();
  }
  const h1 = html.match(/<h1[^>]*>([\s\S]*?)<\/h1>/i);
  if (h1) {
    return stripTags(h1[1]).trim();
  }
  return "";
}

function extractBody(html: string): string {
  // 优先从 starlight 主内容区提取，排除导航、侧边栏、页脚
  const main = html.match(/<main[^>]*>([\s\S]*?)<\/main>/i)?.[1];
  const content = main ?? html;

  // 去掉脚本、样式、导航、页脚、侧边栏、搜索弹窗
  const cleaned = content
    .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, " ")
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, " ")
    .replace(/<nav[^>]*>[\s\S]*?<\/nav>/gi, " ")
    .replace(/<footer[^>]*>[\s\S]*?<\/footer>/gi, " ")
    .replace(/<aside[^>]*>[\s\S]*?<\/aside>/gi, " ")
    .replace(/<header[^>]*>[\s\S]*?<\/header>/gi, " ")
    .replace(/id="search-wrapper"[\s\S]*?<\/div>/gi, " ")
    .replace(/class="[^"]*search[^"]*"[\s\S]*?<\/div>/gi, " ");

  return stripTags(cleaned).trim();
}

function stripTags(html: string): string {
  return html
    .replace(/<[^>]+>/g, " ")
    .replace(/&nbsp;/g, " ")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&amp;/g, "&")
    .replace(/&quot;/g, '"')
    .replace(/&#39;/g, "'")
    .replace(/\s+/g, " ")
    .trim();
}

export function generateSearchIndex(distDir: string): void {
  const htmlFiles = walk(distDir);
  const docs: SearchDoc[] = [];

  for (const file of htmlFiles) {
    const rel = path.relative(distDir, file).replace(/\\/g, "/");
    const url = "/" + rel;
    const html = readFileSync(file, "utf-8");
    const title = extractTitle(html);
    const body = extractBody(html);

    // 跳过空内容页和 404/搜索页
    if (!body && !title) continue;
    if (url.includes("404") || url.includes("search")) continue;

    docs.push({ url, title, body });
  }

  const indexPath = path.join(distDir, "searchindex.json");
  writeFileSync(indexPath, JSON.stringify({ docs }, null, 2));
  console.log(`[search] generated ${indexPath} with ${docs.length} docs`);

  // 禁用 shiroa 原生的 elasticlunr 搜索脚本，避免与自定义中文搜索冲突
  const internalDir = path.join(distDir, "internal");
  if (existsSync(internalDir)) {
    const searcherPath = path.join(internalDir, "searcher.js");
    writeFileSync(searcherPath, "// disabled by custom search\n");
    console.log(`[search] disabled shiroa native searcher: ${searcherPath}`);
  }
}
