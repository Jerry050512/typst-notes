#import "@preview/shiroa:0.3.1": *
#import templates: markup-rules, equation-rules, theme-box, theme-box-styles-from

#let is-html = is-html-target(exclude-wrapper: true)

// Theme preset used by shiroa's equation/code rules.
#let themes = theme-box-styles-from(
  toml("/web-templates/theme-style.toml"),
  read: it => read(it),
)
#let themed-box = theme-box.with(themes: themes)

// Prefer Source Han Serif for Chinese body text.
#let extra-css = ```css
:root {
  --sl-font: "Source Han Serif SC", "Source Han Serif CN", "Noto Serif SC", "Songti SC", "SimSun", serif;
}

.site-title {
  font-size: 1.2rem;    /* 字号稍微放大 */
  font-weight: 600;     /* 半粗体，加粗但不是 700 那么重 */
  font-style: italic;   /* 斜体 */
}

/* 正文基础字号与行高 */
.sl-markdown-content p,
.sl-markdown-content li,
.sl-markdown-content dt,
.sl-markdown-content dd {
  font-size: 1.125rem;
  line-height: 1.8;
}

/* 正文段落首行缩进与段间距 */
.sl-markdown-content p {
  text-indent: 2em;
  margin-bottom: 0.8em;
}

/* card、列表项、block 公式、figure 内部段落不缩进 */
.typst-card p,
li > p,
.block-equation,
figure > p,
figcaption {
  text-indent: 0 !important;
  margin-bottom: 0;
}

/* 行内公式大小跟随正文字号 */
.inline-equation svg {
  height: auto;
  max-height: 1.5em;
  width: auto;
  vertical-align: -0.25em;
}

/* block 公式间距与大小 */
.block-equation {
  margin-top: 1em;
  margin-bottom: 1em;
}

.block-equation svg {
  max-width: 100%;
  height: auto;
  max-height: 15em;
  width: auto;
}

/* 表格中的公式大小适配 */
.typst-grid-cell .inline-equation svg {
  max-height: 1.1em;
}
```

#let project(title: "", description: "", body) = if is-html {
  import "@preview/shiroa-starlight:0.3.1": starlight

  // Apply markup rules (headings, lists, etc.) for web.
  show: markup-rules.with(themes: themes)

  // Render inline/block equations as SVG via shiroa's own rules.
  show: equation-rules.with(theme-box: themed-box)

  starlight(
    include "/book.typ",
    body,
    title: title,
    description: description,
    enable-search: true,
    extra-assets: (extra-css,),
  )
} else {
  body
}
