#import "@preview/shiroa:0.3.1": *

#show: book

#book-meta(
  title: "Gang's Typst Notes",
  description: "杭州电子科技大学课程笔记",
  repository: "https://github.com/jerry050512/typst-notes",
  authors: ("Gang",),
  language: "zh",
  summary: [
    #prefix-chapter("intro.typ")[欢迎]

    {{ BookSummary }}
  ],
)

#build-meta(dest-dir: "dist")

#import "/web-templates/page.typ": project

#let to-css-length(v) = if type(v) == length {
  str(v.pt()) + "pt"
} else {
  "auto"
}

#let rect-style(it) = {
  let style = "box-sizing:border-box;width:100%;"
  if it.has("fill") and it.fill != none and type(it.fill) == color {
    style += "background:" + it.fill.to-hex() + ";"
  } else {
    style += "background:var(--sl-color-gray-6);"
  }
  if it.has("radius") and it.radius != 0pt {
    if type(it.radius) == length {
      style += "border-radius:" + to-css-length(it.radius) + ";"
    }
  } else {
    style += "border-radius:4px;"
  }
  // 默认内边距，避免文字贴边
  if it.has("inset") and it.inset != 0pt {
    if type(it.inset) == length {
      style += "padding:" + to-css-length(it.inset) + ";"
    } else {
      style += "padding:0.8em 1em;"
    }
  } else {
    style += "padding:0.8em 1em;"
  }
  style += "margin:0.6em 0;"
  style += "border:1px solid var(--sl-color-gray-5);"
  style
}

#let book-page(title: "", description: "", body) = {
  show grid: it => context if is-html-target() {
    let cols = it.columns
    let ncols = if type(cols) == int { cols } else if type(cols) == array { cols.len() } else { 2 }
    let style = "display:grid;grid-template-columns:repeat(" + str(ncols) + ",minmax(0,1fr));gap:1em;margin:0.8em 0;"
    html.elem("div", attrs: (class: "typst-grid", style: style))[
      #for child in it.children [
        #if child.func() == grid.cell [
          #html.elem("div", attrs: (class: "typst-grid-cell"))[#child.body]
        ] else [
          #html.elem("div", attrs: (class: "typst-grid-cell"))[#child]
        ]
      ]
    ]
  }
  show figure: it => context if is-html-target() {
    html.elem("figure", attrs: (class: "typst-figure", style: "margin:1em 0;"))[
      #it.body
      #if it.has("caption") and it.caption != none [
        #html.elem("figcaption", attrs: (style: "font-size:0.875em;color:var(--sl-color-gray-3);text-align:center;margin-top:0.4em;"))[#it.caption.body]
      ]
    ]
  }
  show rect: it => context if is-html-target() {
    html.elem("div", attrs: (class: "typst-rect", style: rect-style(it)))[
      #it.body
    ]
  }
  show align: it => context if is-html-target() {
    let a = it.alignment
    let h = if a == center or a == top + center or a == bottom + center or a == horizon + center {
      "center"
    } else if a == right or a == top + right or a == bottom + right or a == horizon + right {
      "right"
    } else {
      "left"
    }
html.elem("div", attrs: (class: "typst-align typst-align-" + h, style: "text-align:" + h + ";"))[
      #it.body
    ]
  }
  show stack: it => context if is-html-target() {
    let d = it.dir
    let is-row = d == ltr or d == rtl
    let style = if is-row {
      "display:flex;flex-direction:row;align-items:center;"
    } else {
      "display:flex;flex-direction:column;"
    }
    if it.spacing != none and type(it.spacing) == length {
      style += "gap:" + to-css-length(it.spacing) + ";"
    }
    html.elem("div", attrs: (class: "typst-stack", style: style))[
      #for child in it.children [
        #html.elem("div", attrs: (class: "typst-stack-item"))[#child]
      ]
    ]
  }
  // 表格默认单元格内容居中，并在页面上水平居中
  set table(align: center + horizon)
  show table: it => context if is-html-target() {
    html.elem("div", attrs: (class: "typst-table-wrapper", style: "display:flex;justify-content:center;overflow-x:auto;margin:1em 0;"))[
      #it
    ]
  }
  project(title: title, description: description, body)
}
