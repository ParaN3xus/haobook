#import "@preview/marginalia:0.1.3" as marginalia: note, wideblock

#let label-section = <section>
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


#let section(title) = page(
  margin: auto,
  header: none,
  {
    show figure.caption: none
    align(
      center + horizon,
      [
        #figure(
          no-side-caption-tag + text(32pt, strong(smallcaps(title))),
          kind: "section",
          supplement: h(-0.3em),
          numbering: _ => none,
          caption: title,
        ) #label-section
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
      dx: (
        if book {
          if calc.odd(here().page()) {
            -page.margin.inside
          } else {
            -page.margin.outside
          }
        } else {
          -page.margin.left
        }
      ),
      {
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
                    left: if (book) {
                      page.margin.inside
                    } else {
                      page.margin.left
                    },
                  ),
                  width: 100%,
                  align(
                    left + horizon,
                    {
                      set text(14pt)
                      body
                    },
                  ),
                )
              },
            )
          },
        )
      },
    )
    v(img-h - 0.7cm)
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
  }
}
