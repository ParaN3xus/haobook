#import "@preview/marginalia:0.1.3" as marginalia: note
#import "@preview/numbly:0.1.0": numbly
#import "tools.typ": *


#let chapter-fig-eq-no(
  config: (
    (figure.where(kind: image), figure, "1-1"),
    (figure.where(kind: table), figure, "1-1"),
    (figure.where(kind: raw), figure, "1-1"),
    (math.equation, math.equation, "(1-1)"),
  ),
  unnumbered-label: "-",
  body,
) = {
  show heading.where(level: 1): it => {
    config.map(x => counter(x.first())).map(x => x.update(0)).join()
    it
  }
  let h1-counter = counter(heading.where(level: 1))

  show: x => config.fold(
    x,
    (it, config) => {
      let (k, f, n) = config

      show k: set f(
        numbering: _ => {
          numbering(n, ..(h1-counter.get(), counter(k).get()).flatten())
        },
      )

      show selector(k).and(selector(label(unnumbered-label))): set f(numbering: _ => counter(k).update(x => x - 1))
      it
    },
  )
  body
}

#let common-style(body) = {
  show link: set text(blue.lighten(10%))
  show link: underline
  body
}


#let front-matter-style(body) = {
  set page(margin: 2.5cm)
  set par(justify: true)
  show: common-style
  show heading.where(level: 1): x => {
    set text(22pt)
    x
    v(28pt)
  }

  body
}

#let appendix-style(body) = {
  counter(heading).update(0)
  set heading(
    numbering: numbly(
      "{1:A}",
      "{1:A}.{2}",
    ),
  )
  body
}

#let contents-style(body) = {
  // cancel link style
  show link: set text(black)
  show underline: it => it.body

  let indent = 0.7cm
  set outline(
    indent: indent,
    title: {
      heading(
        outlined: true,
        level: 1,
        [
          Contents
          #v(-0.9cm)
        ],
      )
    },
  )
  set outline.entry(fill: repeat(".", gap: 0.2cm))
  show outline.entry: x => {
    if x.element.func() == figure {
      // parts
      link(
        x.element.location(),
        {
          set text(1.3em)
          v(0.4cm)
          smallcaps(strong(x.body()))
          h(1fr)
          strong(x.page())
          v(0cm)
        },
      )
    } else if x.level == 1 {
      // level 1 headings
      link(
        x.element.location(),
        {
          strong({
            let prefix = x.prefix()
            if prefix != none {
              box(width: indent, prefix)
            }
            x.body()
          })
          h(1fr)
          strong(x.page())
        },
      )
      v(0cm)
    } else {
      x
    }
  }
  body
}

#let figure-styles(x) = {
  // figure caption by side
  // skip side figure
  if x.body.func() == func-seq and x.body.children.len() > 0 and x.body.children.first() == no-side-caption-tag {
    return x
  }

  if x.caption != none {
    context {
      show figure.caption: none
      x
      margin-note(
        bold-figure-caption(x.caption, x.location()),
        dy: -measure(x.body).height - 0.65em,
      )
      v(-par.spacing)
    }
  } else {
    x
  }
}

#let ref-styles(x) = {
  // ref bib styles
  // if is bib
  if x.element == none {
    x
    margin-note(
      cite(
        x.target,
        form: "full",
      ),
    )
  } else {
    x
  }
}

#let heading-styles(book: false, x) = {
  if x.body.func() == func-seq and x.body.children.at(0) == no-style-heading {
    // prevent conflicting with img heading
    return x
  }
  if x.level == 1 {
    if type(page.margin) != dictionary {
      return x
    }
    {
      set page(header: none)
      if book {
        pagebreak(to: "odd")
      }
    }
    place(
      top,
      dy: -page.margin.top,
      dx: -book-func(book, _ => page.margin.left, _ => page.margin.inside, _ => 0),
      {
        let bottom-pad = 6pt
        block(
          width: page.width,
          align(
            right,
            grid(
              columns: (
                auto,
                10pt,
                0pt,
                8pt,
                book-func(book, _ => page.margin.right, _ => page.margin.outside, _ => 0) - 17pt,
              ),
              align: (right + bottom, center, center, center, left + bottom),
              pad(
                text(26pt, x.body),
                bottom: bottom-pad,
              ),
              [],
              line(angle: 90deg, length: 4cm),
              [],
              pad(
                text(74pt, counter(heading).display(heading.numbering)),
                bottom: bottom-pad,
              ),
            ),
          ),
        )
      },
    )
    v(3.5cm)
    context chapter-outline()
  } else if x.level == 2 {
    v(1cm, weak: true)
    set text(14pt)
    x
    v(0.7cm, weak: true)
  } else {
    x
  }
}

#let body-styles(book: false, body) = {
  let config = (
    outer: (far: 2.5cm, width: 5cm, sep: 0.6cm),
    book: book,
  )
  marginalia.configure(..config)

  set page(..marginalia.page-setup(..config))
  set page(footer: side-note-counter.update(0))
  set par(justify: true)

  // heading numbering
  set heading(
    numbering: numbly(
      "{1}",
      "{1}.{2}",
    ),
  )

  show: common-style
  set text(body-font-size)

  // heading style
  show heading: heading-styles.with(book: book)

  // page header
  set page(header: page-header(book))

  show figure: figure-styles

  show ref: ref-styles

  show: chapter-fig-eq-no
  body
}
