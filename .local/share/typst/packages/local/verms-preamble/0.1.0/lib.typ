/// A simple template that looks nice.

#let conf(
  title_,
  authors: ("Aman Verma",),
  paper: "us-letter",
  body,
) = {
  set document(title: title_, author: authors)

  // keep column width below 80 characters.
  let margin = if paper == "us-letter" {
    (x: 1.7in, y: 0.6in)
  } else if paper == "a5" {
    (x: 0.2in, y: 0.4in)
  } else {
    assert(false, message: "unsupported paper type.")
  }
  set page(paper: paper, margin: margin)

  set text(
    font: "Palatino nova W1G",
    fallback: false,
    hyphenate: true,
    region: "US",
  )
  // match body text size.
  show raw: set text(font: "Input Sans", size: 1.03em)
  show math.equation: set text(font: "Euler Math")

  show link: underline.with(offset: 2pt)
  set outline.entry(fill: box(inset: (x: 1em), repeat(".", gap: 0.5em)))
  set list(marker: ([•], [--]))
  set enum(full: true)
  set strong(delta: 200)
  set math.equation(numbering: "(1)")

  set table(
    stroke: (_, y) => (
      top: if y == 0 { 1pt } else if y == 1 { 0.5pt } else { 0pt },
      bottom: 1pt,
    ),
  )

  // TODO:
  // - make tables look nicer.
  // - bibliography heading is not spaced enough.

  show title: it => {
    v(5%)
    set align(center)
    text(weight: "regular", it)
  }

  title()
  {
    set align(center)
    set text(style: "italic")
    authors.join(", ")
  }

  body
}
