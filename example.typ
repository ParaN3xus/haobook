#import "haobook/lib.typ": *
#import "@preview/zebraw:0.5.0": *
#show: zebraw.with(..zebraw-themes.zebra)

#let (
  body-styles,
  normal-page,
  img-heading,
  side-figure,
) = template(book: false)

#cover(
  title: [
    Example and Documentation \
    of the HaoBook Template
  ],
  author: "ParaN3xus",
  date: datetime(year: 2025, month: 4, day: 6),
)

#epigraph[
  By `epigraph`, you can add a quote or a saying at the beginning of the book.
]

#preface[
  #let l-marginalia = link("https://github.com/nleanba/typst-marginalia")[marginalia]
  #let l-yexiang1992 = link("https://github.com/yexiang1992")[\@yexiang1992]

  This is a preface. You can add some information about the book here by calling `preface`.

  The template is heavily inspired by the LaTeX book template #link("https://github.com/fmarotta/kaobook")[kaobook], and was sponsored by #l-yexiang1992. Without the developers of kaobook and the support of #l-yexiang1992, this template would not have been possible.

  During the development of this template, I have also referenced the implementations of #link("https://github.com/samuelireson/project-iii-typst")[project-iii-typst] and #link("https://github.com/nogula/tufte-memo")[tufte-memo]. They are all excellent templates that you might want to explore if interested. The key feature of this template—sidenotes—is implemented using #l-marginalia by #link("https://github.com/nleanba")[\@nleanba]. I must emphasize that #l-marginalia's implementation is truly outstanding. If you simply want to add sidenotes to your document, I recommend using #l-marginalia directly, as it offers more power and customization options than this template.

  This document serves both as a test document and a tutorial for the template. You can find the source code in the `example.typ` file. The template is designed to be user-friendly and customizable, allowing you to adapt it to your specific requirements.
  #align(right)[_ParaN3xus_]
]

#contents

#show: body-styles

#part[Specifications]
= Features
In this chapter, I will show you all the features of the template.

== Front Matter
As you can see, the template provides all those front matter pages before this page. You can use them to add a cover page, an epigraph, a preface, and a table of contents to your document.

== Margin-related Features
=== Automatically
==== Margin position
You may want to publish your book in a way that the margin notes are on the left side of the page for odd pages and on the right side for even pages. This template provides you with this feature. You can enable it by using the `book: true` parameter when calling the `template` function.

==== Chapter outline
You may have noticed that the chapter outline is automatically generated.

==== References
When I'm referencing something great@maedje2022typst, a detailed reference will be shown in the margin.

==== Figures <sect-feat-figures>
When I'm adding a figure, the caption will be shown in the margin.

#figure(
  rect(
    width: 100%,
    height: 1cm,
    fill: gradient.linear(..color.map.rainbow),
  ),
  caption: [A rainbow],
)

=== Manually
==== Side Notes
You can use `side-note` and `margin-note`#margin-note[A margin note.] to add notes to the document. Just like what#side-note[A side note.] was shown on the right side.

==== Side Figures
You can use `side-figure` to add a figure like @fig-circle to the document.

You might wonder why you can't simply use `figure` inside `margin-note`. This would cause conflicts with the figure caption styles shown in @sect-feat-figures, so you need to use `side-figure` instead.
#side-figure(
  figure(
    circle(),
    caption: "A circle",
  ),
  label: <fig-circle>,
  dy: -4em,
)

==== Wide Block
You can use `wideblock` to add a block that spans the whole page. This is useful for adding text or figures that need to extend across the entire page width.

#wideblock(
  figure(
    rect(
      width: 100%,
      height: 1cm,
      fill: gradient.linear(..color.map.rainbow),
    ),
    caption: [A wide rainbow],
  ),
)

== General Styles
You've already seen the general styles of the template, including heading styles, page headers, etc.

You may have also noticed that figure numbering#side-note[Actually the counters affected are:
- `figure.where(kind: image)`
- `figure.where(kind: table)`
- `figure.where(kind: raw)`
- `math.equation`.
] follows the format `chapno`-`figno`. This is already implemented in the template, so there's no need to use `i-figured`.

// = Usage of the Template
#img-heading(
  [Usage of the Template],
  read("assets/banner.png", encoding: none),
  label: <chapter-usage>,
)
The template is designed to be easy to use. You can use it to create a book or a report with a beautiful layout.

In this chapter, I will show you how to initialize the template and use a variety of utility functions provided.

== Importing the Template
To use the template, you need to import the `lib.typ` file and call the `template` function.

```typ
#import "haobook/lib.typ": *

// Pass book: true parameter to use book mode
#let (body-styles, normal-page, img-heading, side-figure) = template(book: true)
```

When calling the `template` function, you can pass a parameter `book` to specify whether you are creating a book with alternating margin notes position or a report with consistent margin position. The default value is `false`.

In addition to the four functions returned by `template`, functions independent of book mode are also imported. All of these functions are:
- Styles:
  - `front-matter-style(body)`: Style for front matter pages.
  - `appendix-style(body)`: Style for appendix pages.
  - `body-styles(body)`: Style for body pages.
- Pages#side-note[Some of them like `contents` and `normal-page` are not necessarily limited to one page.]:
  - `cover(title: "The Title", author: "The Author", date: datetime.today())`: Add a cover page to the document.
  - `epigraph(body)`: Add an epigraph to the document.
  - `preface(body)`: Add a preface to the document.
  - `contents`: Add a table of contents to the document.
  - `bib(body)`: Add a bibliography to the document.
  - `part(body)`: Add a part page to the document.
  - `normal-page(body)`: Add normal pages without side notes to the document.
- Tools:
  - `side-note(body, dy: 0em)`: Add a side note#side-note[`side-note` has numbering.] to the document.
  - `margin-note(body, dy: 0em)`: Add a margin note#margin-note[`margin-note` doesn't have numbering.] to the document.
  - `side-figure(figure, label: none, dy: 0em)`: Add a side figure to the document.
  - `wideblock(body)`: Add a wide block to the document.
  - `img-heading(body, img, label: none)`: Add a heading of level 1 with a banner image to the document.

== Suggested Document Structure
Overall, your document should be structured like this:

```typ
#import "haobook/lib.typ": *
#let (body-styles, normal-page, img-heading, side-figure) = template(book: true)

// frontmatter
#cover(
  // title: "The Title",
  // author: "The Author",
  // date: datetime.today(),
)
#epigraph[
  // Add an epigraph to the document.
]
#preface[
  // Add a preface to the document.
]
#contents

// body
#show: body-styles

...

// appendix
#part[Appendix]
#show: appendix-style

...
```

For the body of the document, the template provides you with at least three hierarchical levels of structure:
- `part`#side-note[A part is optional. You can create a level 1 heading without any part just like @chapter-usage.]: The `part` will create a single page with a title. You can use it to create a new chapter or a new part in your document.
- `= Heading` or `img-heading`: The level 1 heading will create a chapter starting from a new page#side-note[With a chapter outline just like the one at the beginning of this chapter]. Specifically, the `img-heading` will create a heading with an image banner.
- `== Section`: The level 2 heading will create a section.
- `...`: You can use more `=` to create deeper levels of headings. The template won't style them for you.

For the appendix, it's almost the same as the body. But their heading numbering is `"A.1"`.

== Usage of Some Functions
In this chapter, I will show you how to use some functions, mainly tool functions, as well as some page functions.
=== Side Note
Two types of notes are provided in the template:
- `side-note`: The `side-note` will create a side note with numbering#side-note[Like this]. Its numbering will be reset for each page.
- `margin-note`: The `margin-note` will create a margin note without numbering#margin-note[Like this]. And thus, there won't be any mark in the main text.

For both types of notes, you can use the `dy` parameter to specify the vertical position of the note. The default value is `0em`, which means the note will be placed at the same vertical position as the main text. You can use a negative value to move the note up, or a positive value to move it down.

=== Side Figure
The `side-figure` will create a side figure with a caption. You can use it to create a figure with a caption on the side of the page. The caption will be numbered according to the chapter.

Here is an example of how to use the `side-figure`:
```typ
#side-figure(
  figure(
    rect(),
    caption: "A rectangle",
  ),
  label: <fig-rect>,
)
```
#side-figure(
  figure(
    rect(),
    caption: "A rectangle",
  ),
  label: <fig-rect>,
)

As you can see, the `side-figure` will create a figure with a caption on the side of the page, just like @fig-rect.

You can also use the `dy` parameter to specify the vertical position of the figure.

=== Wide Block
Sometimes, you may want to create a wide block of content that spans the whole page. You can use the `wideblock` function to do this:
```typ
#wideblock(
  figure(
    rect(
      width: 100%,
      height: 1cm,
      fill: gradient.linear(..color.map.rainbow),
    ),
    caption: [Another wide rainbow],
  ),
)
```
#wideblock(
  figure(
    rect(
      width: 100%,
      height: 1cm,
      fill: gradient.linear(..color.map.rainbow),
    ),
    caption: [Another wide rainbow],
  ),
)

=== Image Heading
The `img-heading` function will create a level 1 heading with an image banner.

Actually, it's more like an example of alternative styles for level 1 headings. If you don't like it, you can modify it to your own style.


```typ
#img-heading(
  [Usage of the Template],
  read("assets/banner.png", encoding: none),
  label: <chapter-usage>,
)
```
The effect is shown in @chapter-usage.

Note that you should use the `label` parameter to specify the label of the heading, and you have to use the `read` function to read the image file, otherwise the root of the path will be inside the template folder#side-note[Which is not what we want].


=== Bibliography
```typ
#bib(read("bib.bib"))
```
The `bib` function will create a bibliography page with the references in the `bib.bib` file.

Note that you should use the `read` function to read the `bib.bib` file, for the same reason as explained for `img-heading`.

=== Normal Page
The `normal-page` function#side-note[It's just a wrapper of `set page(...)`] will create a normal page without any side notes. You can use it to create a page with only the main text.

Actually it creates normal "pages" since if you pass too much content to it, it will create multiple pages.

= Compatibility
== Margin Notes Packages
The template is based on the `marginalia` package, so it should be compatible with the `marginalia` package.

Regarding `marge`, `drafting`, or other margin-related packages, I'm not certain about their compatibility. However, it's generally not recommended to use them together with the `marginalia` package.

== i-figured
Don't use i-figured with this template. It will cause conflicts with the numbering styles.

If you want to customize the numbering styles, you can examine `chapter-fig-eq-no` and its usage inside `body-styles` in `haobook/styles.typ`.

== Theorems
=== theorion
After a simple test#side-note[A simple "define and reference" test.], I believe the #link("https://github.com/OrangeX4/typst-theorion")[theorion] package is compatible with this template.

It's an excellent package for creating theorems and proofs. You can use it to create theorems, lemmas, corollaries, propositions, definitions, examples, remarks, and proofs.

It's recommended to use `#set-inherited-levels(1)` to make its numbering consistent with the template.

=== ctheorems
After a simple test, I believe the #link("https://github.com/sahasatvik/typst-theorems")[ctheorems] package is compatible with this template.

It's recommended to set `base_level: 1` when defining thmboxes to make its numbering consistent with the template. Also, to ensure the style of `ref`#side-note[The default style of ctheorems `ref` is affected by the show rule of `link`, so it will be blue and underlined without action.] to theorems is consistent with the template, you are recommended to use the following `show` rule:


```typ
#show ref: it => {
  if it.element == none or it.element.func() != figure or it.element.kind != "thmenv" {
    return it
  }

  show link: set text(black)
  show underline: x => x.body
  it
}
```

=== thmbox
After a simple test, I believe the #link("https://github.com/s15n/typst-thmbox")[thmbox] package is compatible with this template.

It's recommended to set fonts for thmboxes to make them consistent with the template:

```typ
#import "@preview/thmbox:0.2.0": *

#let (thmbox, proof, theorem, proposition, lemma, corollary, definition, example, remark, note, exercise, algorithm, claim, axiom) = (thmbox, proof, theorem, proposition, lemma, corollary, definition, example, remark, note, exercise, algorithm, claim, axiom).map(x => x.with(
  title-fonts: "Libertinus Serif",
  sans-fonts: "Libertinus Serif",
))
#show: thmbox-init()
```

=== lemmify
It works fine, but due to its own bug#side-note[I'm not entirely sure, but once I've set some heading numbering, the `max-reset-level` parameter stopped working.], the numbering is not consistent with the template.

=== frame-it
It's completely#side-note[The theorem body simply disappears.] incompatible with this template. It causes conflicts with the figure caption styles.

=== great-theorems
It's completely incompatible with this template. It causes conflicts with the heading numbering#side-note[Actually the conflicting part is inside `rich-counters`, so that may be another incompatible package.] styles.

#part[Appendix]

#show: appendix-style

#bib(read("bib.bib"))

= Notes
I hate writing notes.


