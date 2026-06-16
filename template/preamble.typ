// ============================================================
// NovaForge — 计算机视觉期末复习 · Typst Preamble
// ============================================================

#import "@preview/cetz:0.3.4": canvas, draw

// ── 颜色系统 ──────────────────────────────────────────────
#let titlecolor      = rgb("#1a3a6b")   // 深蓝：主标题
#let sectionbg       = rgb("#dce8f7")   // 浅蓝灰：标题背景
#let emphcolor       = rgb("#c0392b")   // 橙红：强调
#let supercolor      = rgb("#6c3483")   // 紫红：真题标签
#let examplecolor    = rgb("#1e8449")   // 墨绿：答案/例题
#let praccolor       = rgb("#0e6655")   // 深绿：练习
#let hintcolor       = rgb("#145a7c")   // 蓝色：提示
#let warncolor       = rgb("#784212")   // 棕色：警告/易错
#let graycolor       = rgb("#555555")   // 灰：辅助文字
#let warnboxbg       = rgb("#fdf3e7")   // 浅橙：警告框背景
#let infoboxbg       = rgb("#eaf4fb")   // 浅蓝：提示框背景
#let methodboxbg     = rgb("#f0f7ee")   // 浅绿：方法速通背景
#let intuitionbg     = rgb("#fff8e1")   // 浅黄：直觉理解背景
#let intuitionborder = rgb("#f39c12")   // 橙色：直觉理解边框
#let intuitiontext   = rgb("#e67e22")   // 深橙：直觉理解文字
#let examplebg       = rgb("#f0faf0")   // 浅绿：例题背景
#let exercisebg      = rgb("#f5f0ff")   // 浅紫：练习背景
#let exercisecolor   = rgb("#7d3c98")   // 紫色：练习主色

// ── 行内标记 ─────────────────────────────────────────────
#let key(body)   = text(fill: emphcolor, weight: "bold", body)
#let super-note(body) = text(fill: supercolor, weight: "bold", body)
#let hint(body)  = text(fill: hintcolor, body)
#let warn(body)  = text(fill: warncolor, weight: "bold", body)

// ── 知识点标题栏 ─────────────────────────────────────────
#let knowtitle(body) = {
  v(0.4em)
  block(
    fill: sectionbg,
    inset: (x: 8pt, y: 5pt),
    radius: 3pt,
    width: 100%,
    text(fill: titlecolor, weight: "bold", size: 9.5pt, body)
  )
  v(0.2em)
}

// ── 公式框 ───────────────────────────────────────────────
#let formula(body) = {
  v(0.3em)
  align(center,
    block(
      stroke: (paint: titlecolor, thickness: 0.8pt),
      inset: (x: 12pt, y: 7pt),
      radius: 3pt,
      width: 92%,
      text(fill: titlecolor, size: 12pt, body)
    )
  )
  v(0.2em)
}

// ── 年份标签 ─────────────────────────────────────────────
#let yearlabel(year, info: "") = {
  let label-text = if info == "" { "[" + year + "年]" } else { "[" + year + "年" + info + "]" }
  text(fill: supercolor, size: 9pt, weight: "bold", label-text)
}

// ── 真题环境 ─────────────────────────────────────────────
#let examenv(title: "", body) = {
  v(0.3em)
  block(
    stroke: (paint: examplecolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 8pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: examplecolor, weight: "bold", size: 9pt, "【真题】" + title)
      v(0.3em)
      body
    }
  )
  v(0.2em)
}

// ── 练习环境（留空） ──────────────────────────────────────
#let pracenv(title: "", id: "", body) = {
  v(0.3em)
  block(
    stroke: (paint: praccolor, thickness: 0.8pt, dash: "dashed"),
    inset: (x: 10pt, y: 8pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: praccolor, weight: "bold", size: 9pt, "【练习" + id + "】" + title)
      v(0.3em)
      body
      v(0.3em)
      text(fill: graycolor, size: 8pt, style: "italic", "（答案见末节）")
    }
  )
  v(0.2em)
}

// ── 答案条目 ─────────────────────────────────────────────
#let answer(id, body) = {
  v(0.4em)
  text(fill: examplecolor, weight: "bold", size: 9pt, "答案 " + id + "：")
  h(0.3em)
  body
  v(0.2em)
}

// ── 警告框（易错点） ──────────────────────────────────────
#let warnbox(body) = {
  v(0.3em)
  block(
    fill: warnboxbg,
    stroke: (paint: warncolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 7pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: warncolor, weight: "bold", size: 9pt, "⚠ 易错提醒：")
      h(0.4em)
      body
    }
  )
  v(0.2em)
}

// ── 提示框 ────────────────────────────────────────────────
#let infobox(body) = {
  v(0.3em)
  block(
    fill: infoboxbg,
    stroke: (paint: hintcolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 7pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: hintcolor, weight: "bold", size: 9pt, "💡 提示：")
      h(0.4em)
      body
    }
  )
  v(0.2em)
}

// ── 方法速通块 ────────────────────────────────────────────
#let methodblock(body) = {
  v(0.3em)
  block(
    fill: methodboxbg,
    stroke: (paint: examplecolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 7pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: examplecolor, weight: "bold", size: 9pt, "方法速通：")
      v(0.25em)
      body
    }
  )
  v(0.2em)
}

// ── 章节笔记专用：7步标签 ────────────────────────────────
#let stepbox(num, label, body) = {
  v(0.5em)
  grid(
    columns: (28pt, 1fr),
    column-gutter: 6pt,
    block(
      fill: titlecolor,
      inset: (x: 4pt, y: 5pt),
      radius: 3pt,
      align(center, text(fill: white, weight: "bold", size: 9pt, num))
    ),
    block(
      fill: sectionbg,
      inset: (x: 8pt, y: 5pt),
      radius: (top-right: 3pt, bottom-right: 3pt),
      width: 100%,
      text(fill: titlecolor, weight: "bold", size: 9.5pt, label)
    )
  )
  v(0.3em)
  body
  v(0.3em)
}

// ── 直觉提示框 ────────────────────────────────────────────
#let intuition(body) = {
  v(0.3em)
  block(
    fill: intuitionbg,
    stroke: (paint: intuitionborder, thickness: 0.8pt),
    inset: (x: 10pt, y: 7pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: intuitiontext, weight: "bold", size: 9pt, "🔍 直觉理解：")
      h(0.3em)
      body
    }
  )
  v(0.2em)
}

// ── 例题环境（章节笔记，带完整解答） ───────────────────────
#let example(title: "", body) = {
  v(0.3em)
  block(
    fill: examplebg,
    stroke: (paint: examplecolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 8pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: examplecolor, weight: "bold", size: 9pt, "【例题】" + title)
      v(0.3em)
      body
    }
  )
  v(0.2em)
}

// ── 练习（章节笔记，带解答） ──────────────────────────────
#let exercise(title: "", body) = {
  v(0.3em)
  block(
    fill: exercisebg,
    stroke: (paint: exercisecolor, thickness: 0.8pt),
    inset: (x: 10pt, y: 8pt),
    radius: 3pt,
    width: 100%,
    {
      text(fill: exercisecolor, weight: "bold", size: 9pt, "【练习】" + title)
      v(0.3em)
      body
    }
  )
  v(0.2em)
}