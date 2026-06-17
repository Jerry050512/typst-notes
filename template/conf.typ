#import "preamble.typ": *
#import "@preview/shiroa:0.3.1": is-html-target

#let is-html = is-html-target()

#let conf(
  title: none,
  authors: (),
  doc,
) = {
  set text(
    font: (
      "New Computer Modern",
      (name: "思源宋體 TW", covers: "latin-in-cjk"),
      (name: "Source Han Serif", covers: "latin-in-cjk"),
    ),
    lang: "zh",
    size: 12pt,
  )

  set heading(
    numbering: "1.1"
  )

  set list(
    marker: ("▪", )
  )

  if not is-html {
    set page(
      header: align(
        right,
        title
      ),
      footer: align(
        right,
        [Typst Version: #sys.version]
      )
    )
  }

  if not is-html {
    show heading.where(
      level: 1
    ): it => block(width: 100%)[
      #block()
      #set align(center)
      #set text(
        size: 20pt
      )
      #it
      #block()
    ]

    set align(center)
    text(30pt, title, weight: "bold")

    {
      set text(
        size: 14pt
      )
      let count = authors.len()
      let ncols = calc.min(count, 3)
      grid(
        columns: (1fr,) * ncols,
        row-gutter: 24pt,
        ..authors.map(author => [
          #author.name \
          #author.affiliation \
          #link("mailto:" + author.email)
        ]),
      )

      align(center)[
        Update: #datetime.today().display()
      ]

      line(length: 60%, stroke: (paint: titlecolor, thickness: 1.2pt))
    }

    set align(left)

    outline()
  }

  // pagebreak()
  set par(
    justify: true, // for Chinese alignment.
  )

  if not is-html {
    show heading.where(level: 1): it => {
      counter(math.equation).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: raw)).update(0)
      pagebreak(weak: true)
      v(0.6em)
      it
      v(0.4em)
    }
  }

  show heading.where(level: 2): it => {
    v(0.5em)
    stack(
      spacing: 3pt,
      text(fill: titlecolor, weight: "bold", size: 14pt, "▌ " + it.body.fields().at("text", default: "")),
      line(length: 100%, stroke: (paint: titlecolor, thickness: 0.5pt))
    )
    v(0.2em)
  }
  show heading.where(level: 3): it => {
    v(0.3em)
    text(fill: titlecolor, weight: "bold", size: 12pt, "◆ " + it.body.fields().at("text", default: ""))
    v(0.1em)
  }

  set figure(numbering: num =>
   (counter(heading.where(level: 1)).get() + (num,)).map(str).join("."))

  show table: it => align(center, it)

  set table(
    inset: 10pt,
    align: horizon,
    fill: (x, y) => if y == 0 { gray.lighten(50%) },
    stroke: 0.5pt + gray,
  )

  doc
}
