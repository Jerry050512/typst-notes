#import "@preview/cetz:0.3.4"

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
) = {
  box(
    fill: color, 
    radius: radius, 
    inset: inset, 
    width: width, 
  )[
    #set align(center)
    #set par(justify: true)
    #if title != none {
      text(title, weight: "bold")
      linebreak()
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

#let emph_box(body, expend: false) = {
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