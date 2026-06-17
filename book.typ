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

        = 计算机视觉
    - #chapter("web-notes/Computer-Vision-note.typ")[计算机视觉（全篇）]
    = 信号与系统
    - #chapter("web-notes/Signals-and-Systems-note.typ")[信号与系统（全篇）]
    - #chapter("web-notes/Signals-and-Systems-practice.typ")[信号与系统（练习）]
    = 计算机网络与技术
    - #chapter("web-notes/Computer-Network-01-introduction.typ")[01-introduction]
    - #chapter("web-notes/Computer-Network-02-physical.typ")[02-physical]
    - #chapter("web-notes/Computer-Network-03-links.typ")[03-links]
    - #chapter("web-notes/Computer-Network-04-internet.typ")[04-internet]
    - #chapter("web-notes/Computer-Network-05-transport.typ")[05-transport]
    - #chapter("web-notes/Computer-Network-06-applications.typ")[06-applications]
    - #chapter("web-notes/Computer-Network-practice.typ")[计算机网络与技术（练习）]
    = 神经网络与深度学习
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-01-introduction.typ")[01-introduction]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-02-feedforward-network.typ")[02-feedforward-network]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-03-convolutional-neuro-network.typ")[03-convolutional-neuro-network]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-04-recurrent-neuro-network.typ")[循环神经网络]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-05-network-optimization-and-regulation.typ")[05-network-optimization-and-regulation]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-06-memory.typ")[06-memory]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-07-unsupervised-learning.typ")[07-unsupervised-learning]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-08-model-independent-learning-methods.typ")[08-model-independent-learning-methods]
    - #chapter("web-notes/Neuro-Network-and-Deep-Learning-practice.typ")[神经网络与深度学习（练习）]
    = 模式识别与机器学习
    - #chapter("web-notes/Pattern-Recoginition-and-Machine-Learning-note.typ")[模式识别与机器学习（全篇）]
    = 控制工程
    - #chapter("web-notes/Control-Engineering-note.typ")[控制工程（全篇）]
    - #chapter("web-notes/Control-Engineering-practice.typ")[控制工程（练习）]
    = 微机原理
    - #chapter("web-notes/Microcomputer-note.typ")[微机原理（全篇）]
    - #chapter("web-notes/Microcomputer-practice.typ")[微机原理（练习）]
    = 电路与电子学
    - #chapter("web-notes/Circuits-and-Electronics-note.typ")[电路与电子学（全篇）]
    - #chapter("web-notes/Circuits-and-Electronics-practice.typ")[电路与电子学（练习）]
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
  project(title: title, description: description, body)
}
