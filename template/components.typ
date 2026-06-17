#import "@preview/cetz:0.3.4"
#import "@preview/shiroa:0.3.1": is-html-target

#let question(
  question,
  number: none,
) = {
  emoji.book
  if number != none {
    text(number, size: 14pt, weight: "bold")
    text(" ", size: 14pt, weight: "bold")
  }
  question
}

#let answer(
  answer,
  number: none,
) = {
  emoji.key
  if number != none {
    text(number, size: 14pt, weight: "bold")
    text(" ", size: 14pt, weight: "bold")
  }
  answer
}

#let card(
  body, 
  title: none, 
  color: luma(90%), 
  radius: 4pt, 
  inset: 5pt, 
  width: auto, 
  alignment: center, 
) = context if is-html-target() {
  html.elem(
    "div",
    attrs: (
      class: "typst-card",
      style: "background:#e6e6e6;border-radius:4px;padding:5px;text-align:center;width:100%;box-sizing:border-box;",
    ),
  )[
    #if title != none [
      #html.elem("div", attrs: (style: "font-weight:bold;margin-bottom:0.4em;"))[#title]
    ]
    #body
  ]
} else {
  box(
    fill: color, 
    radius: radius, 
    inset: inset, 
    width: width, 
  )[
    #set align(alignment)
    #set par(justify: true)
    #if title != none {
      align(center, text(title, weight: "bold"))
      // linebreak()
    }
    #body
  ]
}

#let junction(obj_name: "junction") = {
  import cetz.draw: *
  set-style(mark: (end: none))
  line((rel: (.3, 0)), (rel: (45deg, .3)))
  line((rel: (45deg, -.3)), (rel: (135deg, .3)))
  line((rel: (135deg, -.3)), (rel: (225deg, .3)))
  line((rel: (225deg, -.3)), (rel: (315deg, .3)))
  circle((rel: (315deg, -.3)), radius: .3, name: obj_name)
  set-style(mark: (end: ">", fill: black))
}

#let emph_box(body, expend: false) = context if is-html-target() {
  let w = if expend { "100%" } else { "auto" }
  html.elem(
    "div",
    attrs: (
      class: "typst-emph-box",
      style: "border:1px solid var(--sl-color-gray-5, rgba(128,128,128,0.3));border-radius:4px;padding:5px;margin:0.8em auto;text-align:center;width:" + w + ";box-sizing:border-box;",
    ),
  )[#body]
} else {
  let w = auto
  if expend {
    w = 100%
  }
  align(
    center, 
      rect(
        body, 
        inset: 5pt, 
        width: w, 
      ), 
  )
}
