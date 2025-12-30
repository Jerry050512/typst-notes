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
  )

  set heading(
    numbering: "1.1"
  )

  set list(
    marker: ("▪", )
  )

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
  }



  set align(left)
  // set par(
  //   first-line-indent: (
  //     amount: 2em,
  //     all: true,
  //   ),
  //   hanging-indent: 0.5em,
  // )
  // set enum(
  //   indent: 0.5em,
  // )
  // set list(
  //   indent: 0.5em,
  // )
  // set terms(
  //   indent: 0.5em,
  // )

  outline()

  // pagebreak()
  set par(
    justify: true, // for Chinese alignment.
  )

  show heading.where(level: 1): it => {
    pagebreak()
    it
  }

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  set figure(numbering: num =>
   (counter(heading.where(level: 1)).get() + (num,)).map(str).join("."))

  show table: it => align(center, it)

  set table(
    fill: (x, y) => if y == 0 {luma(80%)},
    align: center+horizon,
  )

  doc
}