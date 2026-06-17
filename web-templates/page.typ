#import "@preview/shiroa:0.3.1": *
#import templates: equation-rules, theme-box, theme-box-styles-from

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
```

#let project(title: "", description: "", body) = if is-html {
  import "@preview/shiroa-starlight:0.3.1": starlight

  // Render inline/block equations as SVG via shiroa's own rules.
  show: equation-rules.with(theme-box: themed-box)

  starlight(
    include "/book.typ",
    body,
    title: title,
    description: description,
    extra-assets: (extra-css,),
  )
} else {
  body
}
