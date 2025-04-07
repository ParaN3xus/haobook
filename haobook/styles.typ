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
  // cancle link style
  show link: set text(black)
  show underline: it => it.body

  let indent = 0.7cm
  set outline(
    indent: x => {
      if x == 0 {
        return 0em
      } else {
        return indent * (x)
      }
    },
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
      link(
        x.element.location(),
        {
          set text(1.3em)
          v(0.4cm)
          smallcaps(
            strong({
              x.body()
            }),
          )
          h(1fr)
          strong(x.page())
          v(0cm)
        },
      )
    } else if x.level == 1 {
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
  show heading: x => {
    if x.body.func() == func-seq and x.body.children.at(0) == no-style-heading {
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
        dx: (
          if book {
            if calc.odd(x.location().page()) {
              -page.margin.inside
            } else {
              -page.margin.outside
            }
          } else {
            -page.margin.right
          }
        ),
        {
          let bottom-pad = 6pt
          block(
            width: page.width,
            grid(
              columns: (
                1fr,
                0pt,
                if book {
                  page.margin.outside
                } else {
                  page.margin.left
                }
                  - 6pt,
              ),
              align: (right + bottom, center, left + bottom),
              ..(
                pad(
                  text(26pt, x.body) + h(10pt),
                  bottom: bottom-pad,
                ),
                line(angle: 90deg, length: 4cm),
                pad(
                  h(8pt) + text(74pt, counter(heading).display(heading.numbering)),
                  bottom: bottom-pad,
                ),
              ),
            ),
          )
        },
      )
      v(3.5cm)
      // chapter outline
      place({
        v(0.3cm)
        note(
          numbered: false,
          {
            set outline.entry(fill: repeat(".", gap: 0.1cm))
            show outline.entry: x => {
              set text(body-font-size)
              strong(x)
              h(0em)
            }
            outline(
              title: none,
              indent: 0em,
              target: {
                let s = selector(heading.where(level: 2)).after(here())

                let next-heading = query(heading.where(level: 1).after(here()))
                if next-heading.len() > 1 {
                  s = s.before(next-heading.at(1).location())
                }
                s
              },
            )
          },
        )
      })
    } else if x.level == 2 {
      v(0.4cm)
      set text(14pt)
      x
      v(0.3cm)
    } else {
      x
    }
  }

  // page header
  set page(
    header: context {
      let headings = query(selector(heading.where(level: 1)).after(here()))
      if headings.len() != 0 and headings.first().location().page() == here().page() {
        return
      }
      headings = query(selector(heading.where(level: 1)).before(here()))
      if headings.len() == 0 {
        return
      }
      let fst-h = headings.last()
      let pad-b = 3pt

      if type(page.margin) != dictionary {
        return
      }
      move(
        dx: if book {
          if calc.odd(here().page()) {
            -page.margin.inside
          } else {
            -page.margin.outside
          }
        } else {
          -page.margin.left
        },
        {
          let rev-or-not = if book and calc.even(here().page()) {
            x => x.rev()
          } else {
            x => x
          }
          block(
            width: page.width,
            grid(
              columns: rev-or-not((1fr, 0.3cm, 0pt, 0.3cm, 3cm)),
              align: (right, right, center, right, left),
              ..rev-or-not((
                pad(
                  {
                    rev-or-not((
                      (
                        text(
                          style: "italic",
                          fst-h.body,
                        )
                      ),
                      h(0.3em),
                      numbering("1", ..counter(heading).at(fst-h.location())),
                    )).join()
                  },
                  bottom: pad-b,
                ),
                [],
                line(
                  angle: 90deg,
                  stroke: 0.5pt,
                  length: page.margin.top,
                ),
                [],
                pad(str(here().page()), bottom: pad-b),
              ))
            ),
          )
        },
      )
    },
  )

  // figure caption by side
  show figure: x => {
    // skip side figure
    if x.body.func() == func-seq and x.body.children.len() > 0 and x.body.children.first() == no-side-caption-tag {
      return x
    }

    {
      show figure.caption: none
      x
      v(-1em)
    }
    if x.caption != none {
      context {
        margin-note(
          bold-figure-caption(x.caption, x.location()),
          dy: -measure(x.body).height,
        )
      }
    }
  }

  // ref bib style
  show ref: x => {
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

  show: chapter-fig-eq-no
  body
}
