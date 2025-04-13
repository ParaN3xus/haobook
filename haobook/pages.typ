#import "styles.typ": *
#import "tools.typ": label-part

#let normal-page(body, book: false) = {
  set page(margin: (y: 2.5cm, outside: 2.5cm, inside: 2.5cm)) if book
  set page(margin: (y: 2.5cm, left: 2.5cm, right: 2.5cm)) if not book
  body
}

#let cover(
  title: "The Title",
  author: "The Author",
  date: datetime.today(),
) = {
  page({
    align(
      center + horizon,
      {
        text(3em, weight: "bold", title)
        v(1em)
        text(1.5em, "by " + author)
        v(1em)
        text(1.5em, date.display())
      },
    )
  })
}

#let epigraph(
  body,
) = {
  page({
    align(
      center + horizon,
      text(1.5em, body),
    )
  })
}

#let preface(body) = {
  show: front-matter-style
  heading(level: 1, [Preface])
  body
  pagebreak()
}

#let contents = {
  show: front-matter-style
  show: contents-style
  outline(target: selector(heading).or(label-part), depth: 3)
}

#let bib(bib) = {
  heading(level: 1, [Bibliography])
  bibliography(bytes(bib), title: none)
  pagebreak(weak: true)
}
