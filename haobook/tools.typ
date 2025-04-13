#import "@preview/marginalia:0.1.3" as marginalia: note, wideblock

#let label-part = <part>
#let side-note-counter = counter("side-note")
#let no-side-caption-tag = metadata("no-side-caption")
#let no-style-heading = metadata("no-style-heading")
#let body-font-size = 10pt


#let func-seq = [].func()


#let bold-figure-caption(fig-cap, loc) = context {
  strong({
    fig-cap.supplement
    " "
    numbering(fig-cap.numbering, ..fig-cap.counter.at(loc))
    fig-cap.separator
  })
  fig-cap.body
}

#let book-func(book, non-book-f, book-odd-f, book-even-f) = if book {
  if calc.odd(here().page()) {
    book-odd-f(0)
  } else {
    book-even-f(0)
  }
} else {
  non-book-f(0)
}


#let book-value(book, non-book-v, book-odd-v, book-even-v) = if book {
  if calc.odd(here().page()) {
    book-odd-v
  } else {
    book-even-v
  }
} else {
  non-book-v
}

#let rev-or-not(book) = book-value(book, x => x, x => x, x => x.rev())

#let part(title) = page(
  margin: auto,
  header: none,
  {
    show figure.caption: none
    align(
      center + horizon,
      [
        #figure(
          no-side-caption-tag + text(32pt, strong(smallcaps(title))),
          kind: "part",
          supplement: h(-0.3em),
          numbering: _ => none,
          caption: title,
        ) #label-part
      ],
    )
  },
)

#let side-note(body, dy: 0em) = {
  side-note-counter.step()

  context super(side-note-counter.display())
  note(
    dy: dy,
    numbered: false,
    {
      context side-note-counter.display("1:") + h(0.3em)
      body
    },
  )
}

#let margin-note(
  body,
  dy: 0em,
) = note(
  dy: dy,
  numbered: false,
  body,
)

#let side-figure(
  body,
  book: false,
  label: none,
  dy: 0em,
) = {
  margin-note(
    {
      show figure.caption: x => context align(
        if book {
          if calc.odd(here().page()) {
            left
          } else {
            right
          }
        } else {
          left
        },
        {
          context strong(x.supplement + " " + x.counter.display(x.numbering) + x.separator)
          x.body
        },
      )
      show figure: set block(width: 100%)

      let fields = body.fields()
      _ = fields.remove("body")

      body = figure(no-side-caption-tag + body.body, ..fields)
      [#body #label]
    },
    dy: dy,
  )
}

#let page-header(book) = context {
  let h1s = query(selector(heading.where(level: 1)).after(here()))
  if h1s.len() != 0 and h1s.first().location().page() == here().page() {
    // there's a level 1 heading on this page, don't show pago no header
    return
  }

  h1s = query(selector(heading.where(level: 1)).before(here()))
  if h1s.len() == 0 {
    // there's no previous level 1 heading, nothing to show in the header
    return
  }

  let clothest-h1 = h1s.last()
  let pad-b = 3pt

  if type(page.margin) != dictionary {
    // normal page
    return
  }

  move(
    dx: -book-func(book, _ => page.margin.left, _ => page.margin.inside, _ => page.margin.outside),
    {
      let rev-or-not = rev-or-not(book)
      block(
        width: page.width,
        grid(
          columns: rev-or-not((1fr, 0.3cm, 0pt, 0.3cm, 3cm)),
          align: (right, center, center, center, left),
          ..rev-or-not((
            // chapter title
            pad(
              rev-or-not((
                text(
                  style: "italic",
                  clothest-h1.body,
                ),
                h(0.3em),
                numbering("1", ..counter(heading).at(clothest-h1.location())),
              )).join(),
              bottom: pad-b,
            ),
            [],
            // line
            line(
              angle: 90deg,
              stroke: 0.5pt,
              length: page.margin.top,
            ),
            [],
            // page no
            pad(str(here().page()), bottom: pad-b),
          ))
        ),
      )
    },
  )
}

#let chapter-outline() = place({
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
            s = s.before(next-heading.at(0).location())
          }
          s
        },
      )
    },
  )
})

#let img-heading(body, img, book: false, label: none) = {
  body = heading(level: 1, no-style-heading + body)
  if label != none {
    body = [#body #label]
  }

  context {
    if type(page.margin) != dictionary {
      return x
    }
    {
      set page(header: none)
      if book {
        pagebreak(to: "odd")
      }
    }
    let img-h = 9cm

    place(
      top,
      dy: -page.margin.top,
      dx: -book-func(book, _ => page.margin.left, _ => page.margin.inside, _ => page.margin.outside),
      block(
        width: page.width,
        {
          image(
            img,
            width: 100%,
            height: img-h,
            fit: "cover",
          )
          place(
            bottom,
            {
              block(
                fill: luma(81.57%, 91.4%).transparentize(10%),
                stroke: 0pt,
                height: 1.5cm,
                inset: (
                  left: book-func(book, _ => page.margin.left, _ => page.margin.inside, _ => page.margin.inside),
                ),
                width: 100%,
                align(
                  left + horizon,
                  text(14pt, body),
                ),
              )
            },
          )
        },
      ),
    )

    v(img-h - 0.7cm)
    context chapter-outline()
  }
}
