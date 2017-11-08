MiniLaTeX is a subset of LaTeX that can be rendered
into pdf by standard tools such as `pdflatex` or
into HTML by

Example:
```
> import MiniLatex.Driver as MiniLatex
> text = "\\begin{itemize}\n\\item Eggs\n\\item Milk\n\\item Bread\n\\end{itemize}"
> MiniLatex.render text
"<p>\n \n<ul>\n <li class=\"item1\"> Eggs</li>\n <li class=\"item1\"> Milk</li>\n <li class=\"item1\"> Bread</li>\n\n</ul>\n\n</p>"
    : String
```

Thus the rendered text is
```
<p>

<ul>
 <li class="item1"> Eggs</li>
 <li class="item1"> Milk</li>
 <li class="item1"> Bread</li>

</ul>

</p>
```

If your applications simply renders strings of MiniLatex
text to HTML, `Driver.renderMiniLatex` is all you
need from this package.  If you wish to do some
kind of live editing on a piece of text, there is a another,
slightly more complex method.  First, set up an `EditRecord` like this


```
model.editRecord = MiniLatex.setup text
```

Here we assume that `editRecord` is in your model. It will
be used both for the generated HTML and for updating the
HTML if the original text is modified.

To extract the rendered text from the `EditRecord`, use

```
MiniLatex.getRenderedText editRecord
```

To update the `EditRecord` with modified text, use

```
MiniLatex.update editRecord text
```

To summarize, most work can be done with four points of contact
with the MiniLatex API:

1. `MiniLatex.render text`
2. `MiniLatex.setup text`
3. `MiniLatex.getRenderedText editRecord`
4. `MiniLatex.update editRecord text`

The above assumes `import MiniLatex.Driver as MiniLatex`

**Acknowledgments**  I wish to acknowledge the generous help that I have received throughout this project from the community at http://elmlang.slack.com, with special thanks to Ilias van Peer (@ilias).

[Publishing an Elm Package](https://becoming-functional.com/publishing-your-first-elm-package-13d984a1200a)
