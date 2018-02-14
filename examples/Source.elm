module Source exposing (..)


htmlPrefix =
    """
  <html>
  <head>

    <meta charset="utf-8" />

    <style>
     .code {font-family: "Courier New", Courier, monospace; background-color: #f5f5f5; font-weight: 300;}
     .center {margin-left: auto; margin-right: auto;}
     .indent {margin-left: 2em!important}
     .italic {font-style: oblique!important}
     .environment {margin-top: 1em; margin-bottom: 1em;}
     .strong {font-weight: bold}
     .subheading {margin-top: 0.75em; margin-bottom: 0.5em; font-weight: bold}
     .verbatim {margin-top: 1em; margin-bottom: 1em; font-size: 10pt;}
     td {padding-right: 10px;}

       a.linkback:link { color: white;}
       a.linkback:visited { color: white;}
       a.hover:visited { color: red;}
       a.hover:visited { color: blue;}


     a:hover { color: red;}
     a:active { color: blue;}

     .errormessage {white-space: pre-wrap;}

     .title { font-weight: bold; font-size: 1.7em; margin-bottom: 0px; padding-bottom: 0px;}
     .smallskip {margin-top:0; margin-bottom: -12px;}

     .item1 {margin-bottom: 6px;}

     .verse { white-space: pre-line; margin-top:0}
     .authorinfo { white-space: pre-line; margin-top:-8px}

     .ListEnvironment { list-style-type: none; margin-left:8px; padding-left: 8px; margin-top: 0;margin-bottom:12px;}
     .tocTitle { margin-bottom: 0; margin-top:12px; font-weight: bold;}
     .sectionLevel1 {padding-left: 0; margin-left: 0; }
     .sectionLevel2 {padding-left: 8px; margin-left: 8px; }
     .sectionLevel3 {padding-left: 22px; margin-left: 22px; }

    </style>

    <script type="text/javascript" async
          src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML">
    </script>

    <title>MiniLaTeX Demo</title>

  </head>

  <body>

      <script type="text/x-mathjax-config">
         MathJax.Hub.Config(
           { tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]},
            processEscapes: true
            }
      );

    </script>


"""


htmlSuffix =
    """
  </body>
  </html>
"""



{- Examples -}


initialText =
    """

\\title{MiniLaTeX Demo}

\\author{James Carlson}

\\email{jxxcarlson at gmail}

\\date{November 13, 2017}

\\revision{February 1, 2018}

\\maketitle

\\tableofcontents

\\section{Introduction}

MiniLaTeX is a subset of LaTeX which can be displayed in a web browser \\cite{hakernews}. One applies a parser-renderer toolchain to convert MiniLaTeX into HTML, then uses MathJax to render formulas and equations. This document is written in MiniLatex; for additional examples, try the buttons on the lower left, or go to \\href{http://www.knode.io}{www.knode.io}.

Feel free to edit and re-render the text on the left and to experiment with the buttons above. To export a rendered LaTeX file, simply click on the "Export" button above. Your file will be downloaded as "file.html".

Please bear in mind that MiniLaTeX is still an R&D operation \\cite{techreport}. We are working hard to refine its grammar \\cite{grammar} and extend its scope; we welcome bug reports, comments and suggestions.

MiniLatex is written in Elm, the functional language for building web apps developed by Evan Czaplicki, starting with his 2012 senior thesis. Although Elm is especially well-suited for writing a parser for MiniLatex and integrating that parser into an interactive editing environment, MiniLatex does not depend on any particular language. Indeed, we plan a second implementation of the parrser-renderer toolchain in Haskell.

\\section{Examples}

The Pythagorean Theorem, $a^2 + b^2 = c^2$, is useful for computing distances.

Formula \\eqref{integral}is one that you learned in Calculus class.

\\begin{equation}
\\label{integral}
\\int_0^1 x^n dx = \\frac{1}{n+1}
\\end{equation}


\\begin{theorem}
There are infinitely many primes, and each satisfies $a^{p-1} \\equiv 1 \\text{ mod } p$, provided that $p$does not divide $a$.
\\end{theorem}


A Table ...

\\begin{indent}
\\strong{Light Elements}
\\begin{tabular}{ l l l l }
Hydrogen & H & 1 & 1.008 \\\\
Helium & He & 2 & 4.003 \\\\
Lithium& Li & 3 & 6.94 \\\\
Beryllium& Be& 4& 9.012 \\\\
\\end{tabular}
\\end{indent}

An Image ....

\\image{http://psurl.s3.amazonaws.com/images/jc/propagator_t=2-6feb.png}{Free particle propagator}{width: 300, align: center}

A listing.  Note that in the \\italic{source}of the listing, there are no line numbers.

\\strong{MiniLaTeX Abstract Syntax Tree (AST)}

\\begin{listing}

type LatexExpression
= LXString String
| Comment String
| Item Int LatexExpression
| InlineMath String
| DisplayMath String
| Macro String (List LatexExpression)
| Environment String LatexExpression
| LatexList (List LatexExpression)

\\end{listing}


The MiniLaTeX parser reads text and produces an AST. A rendering function converts the AST into HTML. One could easily write functions \\code{render: LatexExpression -> String}to make other conversions.

\\section{Short Writer's Guide}

We plan a complete Writer's Guide for MiniLaTeX. For now, however, just a few pointers.

\\begin{itemize}
\\item Make liberal use of blank lines. Your source text will be much easier to read, and the converter has optimizations that work especially well when this is done.

\\item Equations and environments should have a blank line above one below. Items in lists should be separated by blank lines. This is not strictly necessary, but it helps the converter and it helps you.


\\end{itemize}


\\italic{Fast Render}is an optimization that speeds up parsing and rendering for long documents. Only paragraphs which are changed are re-parsed (expensive) and re-rendered (inexpensive). However, to resolve section numbers, cross-references, etc., a full render is necessary.

All of these operations will have a very significant speed-up when version 0.19 of the Elm compiler is released and when MathJax 3.0 is released and integrated into MiniLaTeX.

\\section{More about MiniLaTeX}

Articles and code:

\\begin{itemize}
\\item \\href{https://hackernoon.com/towards-latex-in-the-browser-2ff4d94a0c08}{Towards LaTeX in the Browser}

\\item \\href{https://github.com/jxxcarlson/minilatexDemo}{Code for the Demo App}

\\item \\href{http://package.elm-lang.org/packages/jxxcarlson/minilatex/latest}{The MiniLatex Elm Library}


\\end{itemize}


To try out MiniLatex for real, sign up for a free account at \\href{http://www.knode.io}{www.knode.io}. The app is still under development &mdash; we need people to test it and give feedback. Contributions to help improve the open-source MiniLatex Parser-Renderer are most welcome. Here is the \\href{https://github.com/jxxcarlson/minilatex}{GitHub repository}. The MiniLatex Demo as well as the app at knode.io are written in \\href{http://elm-lang.org/}{Elm}. We also plan a Haskell version.

Please send comments, bug reports, etc. to jxxcarlson at gmail.

\\section{Technical Note}There is a \\italic{very rough} \\href{http://www.knode.io/#@public/628}{draft grammar}for MiniLaTeX, written mostly in EBNF. However, there are a few productions, notably for environments, which are not context-free. Recall that in a context-free grammar, all productions are of the form $A \\Rightarrow \\beta$, where $A$is a non-terminal symbol and $\\beta$is a sequence of terminals and nonterminals. There are some productions of the form $A\\beta \\Rightarrow \\gamma$, where $\\beta$is a terminal symbol. These are context-sensitive productions, with $\\beta$providing the context.

\\section{Restrictions, Limitations, and Todos}

Below are some of the current restrictions and limitations.


%% COMMENT: below we nest one environment inside another

\\begin{restrictions}
\\begin{enumerate}

\\item The enumerate and itemize environments cannot be nested inside one another.  They
can, however, contain inline math and macros, and they may be contained in other environments,
e.g., theorem.

\\item The tabular environment ignores formatting information and left-justifies everything in the cell.

\\end{enumerate}
\\end{restrictions}

We are working to fix known issues and to expand the scope of MiniLatex.

\\strong{Bibliography}

\\begin{thebibliography}

\\bibitem[HN]{hackernews} \\href{https://hackernoon.com/towards-latex-in-the-browser-2ff4d94a0c08}{Towards Latex in the Browser}

\\bibitem[GR]{grammar} \\href{http://www.knode.io/#@public/628}{MiniLatex Grammar}

\\bibitem[TR]{techreport} \\href{http://www.knode.io/#@public/525}{MiniLatex Technical Report}


\\end{thebibliography}

\\bigskip

\\image{https://cdn-images-1.medium.com/max/1200/1*HlpVE5TFBUp17ua1AdiKpw.gif}{The way we used to do it.}{align: center}

\\begin{comment}

This text

should not appear

\\end{comment}


"""


report =
    """
\\title{MiniLaTeX: Technical Report}

\\author{James Carlson}

\\email{jxxcarlson at gmail}

\\date{October 29, 2017}

\\revision{January 16, 2017}



\\maketitle


\\begin{abstract}
The aims of the MiniLaTeX project are (1) to establish a subset
of LaTeX which can be rendered either as HTML (for the browser) or as PDF (for print and display), (2) to implement a reference parser and renderer for MiniLaTeX, (3) to provide an online editor/reader for MiniLaTeX documents using the parser/renderer.  As proof of concept, this document is written in MiniLaTeX  and is distributed via \\href{http://www.knode.io}{www.knode.io}, an implementation of (3).
To experiment with MiniLaTeX, take a look at the \\href{https://jxxcarlson.github.io/app/minilatex/src/index.html}{Demo App}.
\\end{abstract}


\\strong{Credits.} \\italic{I wish to acknowledge the generous help that I have received throughout this project from the community at } \\href{http://elmlang.slack.com}{elmlang.slack.com}, \\italic{with special thanks to Ilias van Peer.}

\\tableofcontents

\\section{Introduction}


The introduction of TeX by Donald Knuth, LaTeX by Leslie Lamport, and Postscript/PDF by John Warnock, supported by a vigorous open source community, have given mathematicians, physicists, computer scientists, and engineers the tools they need to produce well-structured documents  with mathematical notation typeset to the very highest esthetic standards.  For dissemination by print and PDF, the problem of mathematical communication is solved.

The Web, however, offers different challenges.  The MathJax project (\\href{http://www.mathjax.org}{www.mathjax.org}) addresses many of these challenges, and its use is now ubiquitous on platforms such as mathoverflow and on numerous blogs.  There is, however, a gap.  MathJax beautifully renders the purely mathematical part of the text, like the inline text $\\alpha^2 + \\beta^2 = \\gamma^2$, written as

\\begin{verbatim}
$ \\alpha^2 + \\beta^2 = \\gamma^2 $
\\end{verbatim}

or like the displayed text

$$
   \\int_0^1 x^n dx = \\frac{1}{n+1},
$$

which is written as

\\begin{verbatim}
$$
   \\int_0^1 x^n dx = \\frac{1}{n+1}
$$
\\end{verbatim}

There remains the rest: macros like \\code{emph}, \\code{section}, \\code{label}, \\code{eqref}, \\code{href}, etc., and a multitude of LaTeX environments from \\italic{theorem} and \\italic{definition} to  \\italic{equation}, \\italic{align}, \\italic{tabular}, \\italic{verbatim}, etc.

 It is the aim of this project is to develop a subset of LaTeX, which we call \\italic{MiniLaTeX}, that can be displayed in the browser by a suitable parser-renderer and which can also be run through standard LaTeX tools such as \\code{pdflatex}.

An experimental web app for using MiniLaTeX in the browser can be found at \\href{http://www.knode.io}{www.knode.io}.  For proof-of-concept examples,  see  the document \\xlinkPublic{445}{MiniLaTeX} on that site.

\\strong{Note.} This document is written in a simplified version of MiniLaTeX (version 0.5).  Below, we describes the current state of the version under development for the planned 1.0 release.  Much of the discussion applies to version 0.5 as well.

\\section{Technology}

The MiniLaTeX parser/renderer is written in Elm, the functional language with Haskell-like syntax created by Evan Czaplicki.  Elm is best known as language for building robust front-end apps for the web.  The fact that it also has powerful parser tools makes it an excellent choice for a project like MiniLatex, for which an editor/reader app is needed to make real-world use of the parser/renderer.  The app at \\href{http://www.knode.io}{www.knode.io} talks to a back-end app written using the Phoenix web framework for Elixir  (see \\href{https://elixir-lang.org/}{elixir-lang.org}).  Elixir is the functional programming language based on Erlang created by José Valim.

\\section{Components and Strategy}

The overall flow of data in MiniLatex is

$$
\\text{MiniLaTeX source text} \\longrightarrow
\\text{AST} \\longrightarrow
\\text{HTML}
$$

where the \\code{AST} is an abstract syntax tree consisting of a \\code{LatexExpresssion}, to be defined below.  The parser consumes MiniLaTeX source text and produces an AST.
The renderer converts the AST into HTML.  Rendering takes two forms. In the first form, it transforms a single \\code{LatexExpression} into HTML.  In the second, the source text is broken into a list of paragraphs and an initial \\code{latexState} is defined.  As each paragraph is consumed by the processor, it is parsed, the  \\code{latexState} is updated, and the AST for the paragraph is rendered into HTML, with the result depending on the updated \\code{latexState}.  The result is a list of HTML strings that is concatenated to give the final HTML.  We will also discuss a \\code{differ}, which speeds up the the edit-save-render cycle as experienced by an author.  The idea is to keep track of changes to paragraphs and only re-render what has changed since the last edit.




\\section{AST and Parser}

The core technology of MiniLaTeX is the parser.  It consumes MiniLaTeX source text and produces as output an abstract syntax tree (AST).  The AST  is a list of \\code{LatexExpressions}.  \\code{LatexExpressions} are defined recursively by the following Elm code:

\\begin{verbatim}
type LatexExpression
    = LXString String
    | Comment String
    | Item Int LatexExpression
    | InlineMath String
    | DisplayMath String
    | Macro String (List LatexExpression)
    | Environment String LatexExpression
    | LatexList (List LatexExpression)
\\end{verbatim}

Source text of the form $ \\$ TEXT \\$ $ parses as $\\tt{InlineMath}\\ TEXT$,  and text of the form $ \\$\\$TEXT \\$\\$ $  parses as $\\tt{DisplayMath}\\ TEXT$

Source of the form $\\backslash item\\ TEXT$ maps to $\\tt{Item\\ 1\\ TEXT}$, while
 $\\backslash itemitem\\ TEXT$ maps to $\\tt{Item\\ 2\\ TEXT}$, etc.

A macro like $\\backslash foo\\{1\\}\\{bar\\}$ maps to $\\tt{Macro "foo" ["1", "bar"]}$ -- the string after Macro is the macro name, and this is followed by the argument list, which may be empty.

Finally, an environment like
\\begin{verbatim}
\\begin{theorem}
BODY
\\end{theorem}
\\end{verbatim}

maps to $\\tt{Environment\\ "theorem"\\ PARSE(BODY)}$,
where $\\tt{PARSE(BODY)}$ is the $\\tt{LatexExpression}$ obtaining by parsing $\\tt{BODY}$.

As an example, consider the text below.

\\begin{verbatim}
This is MiniLaTeX:
\\begin{theorem}
  This is a test: $\\alpha^2 = 7$ \\foo{1}
 \\begin{a}
  la di dah
\\end{a}
\\end{theorem}
\\end{verbatim}

Running \\code{MiniLatex.Parser.latexList} on this text results in the following AST:

\\begin{verbatim}
Ok (LatexList (
  LXString "This is MiniLaTeX:",
  [Environment "theorem" (
    LatexList ([
         LXString "This is a test:",
         InlineMath "\\\\alpha^2 = 7",
         Macro "foo" ["1"],
         Environment "a" (
              LatexList ([LXString "la di dah"])
     )]))]))
\\end{verbatim}

At the top level it is a list of \\code{LatexExpressions} -- a string and an \\code{Environment}.
The body of the environment is a list of \\code{LatexExpressions} -- a string, an \\code{InlineMath} element, a \\code{Macro} with one argument, and another \\code{Environment},  This is a structure which \\code{MiniLatex.Render.render} can transform into HTML.

\\subsection{Parser Combinators}

The MiniLaTeX parser, comprising 222 lines of code as of this writing, is built using parser combinators from Evan Czaplicki's \\href{https://github.com/elm-tools/parser}{elm-tools/parser} package.  The combinators are akin to those in the Haskell parsec package.  As as example, the main MiniLatex parsing function is

\\begin{verbatim}
parse : Parser LatexExpression
parse =
    oneOf
        [ texComment
        , lazy (\\_ -> environment)
        , displayMathDollar
        , displayMathBrackets
        , inlineMath
        , macro
        , words
        ]
\\end{verbatim}

This function tries each of its component parsers in order until it finds one that
matches the input text.  The \\code{environment} parser is the most interesting. It captures the environment name and then passes it on to \\code{environmentOfType}.


\\begin{verbatim}
environment : Parser LatexExpression
environment =
    lazy (\\_ -> beginWord |> andThen environmentOfType)
\\end{verbatim}

The \\code{environmentOfType}
function acts as a switching yard, routing the action of the parser to the correct function. The \\italic{enumurate} and \\italic{itemize} environments need special handling, while others are handled by \\code{standardEnvironmentBody}.

\\begin{verbatim}
environmentOfType : String -> Parser LatexExpression
environmentOfType envType =
    let
        endWord =
            "\\\\end{" ++ envType ++ "}"
    in
    case envType of
        "enumerate" ->
            itemEnvironmentBody endWord envType
        "itemize" ->
            itemEnvironmentBody endWord envType
        _ ->
            standardEnvironmentBody endWord envType
\\end{verbatim}

A standard environment such as \\italic{theorem} or \\italic{align} is handled like this:

\\begin{verbatim}
standardEnvironmentBody endWord envType =
    succeed identity
        |. ws
        |= repeat zeroOrMore parse
        |. ws
        |. symbol endWord
        |. ws
        |> map LatexList
        |> map (Environment envType)
\\end{verbatim}

Note the repeated calls to \\code{parse} in the body of \\code{standardEnvironmentBody}.  Thus an environment can contain a nested sequence of environments, or even a tree thereof..
The symbol $|.$ means "use the following parser to recognize text but do not retain it."  Thus $|. \\text{ws}$ means "recognize white space but ignore it."  The symbol  $|$= means "use the following parse and retain what it yields."

\\section{Rendering an AST to HTML}

This section addresses the second step in the pipelne

$$
\\text{MiniLaTeX source text} \\longrightarrow
\\text{AST} \\longrightarrow
\\text{HTML}
$$

Code for the second step is housed in the module \\code{MiniLatex.Render}. The primary function is

\\begin{verbatim}
render : LatexState -> LatexExpression -> String
render latexState latexExpression =
    case latexExpression of
        Comment str ->
            renderComment str
        Macro name args ->
            renderMacro latexState name args
        Item level latexExpression ->
            renderItem latexState level latexExpression
        ETC...
\\end{verbatim}

This function dispatches a given \\code{LatexExpression} to its handler, which then computes a string representing the HTML output.  That output depends on the current \\code{latexState} -- a data structure  which holds information about various counters such as section numbers as well as information about cross-references.  One can call \\code{render} on a default \\code{LateExpression} to convert it to HTML.  However, the usual process for rendering a MiniLaTeX document from scratch is to first transform it into logical paragraphs, i.e., a list of strings, then use the \\code{accumulator} function defined below to transform paragraphs one at a time into HTML, updating the \\code{latexState} with each paragraph.

The accumulator is a function of four variables, as indicated below.  The first argument, \\code{parse}, takes a string as input and parses it to produce a \\code{LatexExpression} as output.  The second, \\code{render}, takes a \\code{LatexExpression} and a \\code{LatexState} as input and produces HTML as output.  The third, \\code{updateState}, takes a \\code{LatexExpression} and a \\code{LatexState} as input and produces a new \\code{LatexState} as output.  The fourth and final argument, \\coce{input}, is the list of strings (logical paragraphs) to be rendered.  The output of the \\code{accumulator} is a tuple consisting of a list of strings, the rendered HTML, and the final \\code{latexState}.

$$
{\\bf accumulator\\ } \\text{parse render updateState inputList} \\longrightarrow (\\text{outputList}, latexState)
$$

The \\code{accumulator} uses \\code{List.foldl} to build up the final list of rendered paragraphs one paragraph at a time, starting with an empty list.  The driver for this operation is the \\code{transformer} function, which we treat below.


\\begin{verbatim}
accumulator :
    (String -> List LatexExpression)
    -> (List LatexExpression -> LatexState -> String)
    -> (List LatexExpression -> LatexState -> LatexState)
    -> List String
    -> ( List String, LatexState )
accumulator parse render updateState inputList =
    inputList
        |> List.foldl (transformer parse render updateState) ( [], Render.emptyLatexState )
\\end{verbatim}

The role of the \\code{transformer} function is to carry forward the current \\code{latexState}, updating it, and transforming \\code{LatexExpressions} into HTML. A kind of transducer, the \\code{transformer} is a function of five variables:

$$
{\\bf transformer\\ } \\text{parse render updateState input acc} \\longrightarrow
(\\text{List renderedInput}, \\text{state})
$$

Here is the code:

\\begin{verbatim}
transformer :
    (input -> parsedInput)
    -> (parsedInput -> state -> renderedInput)
    -> (parsedInput -> state -> state)
    -> input
    -> ( List renderedInput, state )
    -> ( List renderedInput, state )
transformer parse render updateState input acc =
    let
        ( outputList, state ) =
            acc
        parsedInput =
            parse input
        newState =
            updateState parsedInput state
    in
        ( outputList ++ [ render parsedInput newState ], newState )
\\end{verbatim}

To bundle all this code in convenient form, we also define a function

$$
{\\bf transformParagraphs\\ } \\text{List SourceText} \\longrightarrow  \\text{List HTMLText}
$$

that maps a  list of paragraphs of MiniLatex source text to its rendition as list of HTML strings.  The \\code{transformParagraphs} function is defined in terms of the \\code{accumulator}:

\\begin{verbatim}
transformParagraphs : List String -> List String
transformParagraphs paragraphs =
    paragraphs
        |> accumulator Render.parseParagraph renderParagraph updateState
        |> Tuple.first
\\end{verbatim}


\\section{Differ: Speeding up the Edit Cycle}

In the previous section, we described in outline how a MiniLaTeX document is rendered into HTML.  In order to have a fast edit-render cycle, one which feels instantaneous or nearly so to an author, we need an additional construct.  The idea is this.  The app maintains a list $X$ of logical paragraphs for the document being edited, as well as a list $r(X)$ of rendered paragraphs. Suppose that the author makes some edits and pressed the update button.  The app computes a new list of logical paragraphs and compares it with the old.  The old list will have the form $X = \\alpha\\beta\\gamma$ and the new one will have the form $Y = \\alpha\\beta'\\gamma$, where $\\alpha$ is the greatest common prefix and $\\gamma$ is the greatest common suffix.  By greatest common prefix, we mean the largest list $\\alpha$ of contiguous elements of the list $X$ that is also list of contiguous elements of the list $Y$, and such that the first element of $\\alpha$ is the same as the first element of $X$ and also of $Y$.  The largest common suffix is defined similarly.  Note that $r(X) = r(\\alpha)r(\\beta)r(\\gamma)$ and $r(Y) =  r(\\alpha)r(\\beta')r(\\gamma)$.  Thus to compute $r(Y)$, we need only compute $r(\\beta')$, relying on the previously computed $r(\\alpha)$ and $r(\\gamma)$.

While the strategy just described is not the theoretically  most efficient, it aways works and in fact is quite fast in practice because of the typical behavior of authors -- make a few changes, or add a little text, then press the save/update button.  The point is that changes to the text are generally localized.  If  the author  adds, deletes, or changes a single paragraph, at most one paragraph has to be re-rendered.

We now discuss the core code for the strategy for diffing and rendering the list of logical paragraphs.  First comes the data structure to be maintained while editing:

\\begin{verbatim}
type alias EditRecord =
    { paragraphs : List String
    , renderedParagraphs : List String
    }
\\end{verbatim}

To set up this structure when an author begins editing, we make use of the general \\code{initialize} function in module \\code{MiniLatex.Differ}:

\\begin{verbatim}
initialize : (List String -> List String) -> String -> EditRecord
initialize transformParagraphs text =
    let
        paragraphs =
            paragraphify text
        renderedParagraphs =
            transformParagraphs paragraphs
    in
        EditRecord paragraphs renderedParagraphs
\\end{verbatim}


To make use of \\code{Differ.initialize}, we call it with \\code{Accumulator.transformParagraphs}:

\\begin{verbatim}
editRecord = Differ.initialize Accumulator.transformParagraphs
\\end{verbatim}

\\subsection{Inside the Differ}

Let's take a quick look at the operation of the differ.  The basic data structure
is the \\code{DiffRecord}

\\begin{verbatim}
type alias DiffRecord =
    { commonInitialSegment : List String
    , commonTerminalSegment : List String
    , middleSegmentInSource : List String
    , middleSegmentInTarget : List String
    }
\\end{verbatim}

Thus $\\alpha = \\text{commonInitialSegment}$,  $\\beta = \\text{middleSegmentInSource}$,
$\\gamma = \\text{commonTerminalSegment}$, and $\\beta' = \\text{middleSegmentInTarget}$.
These are computed using the function \\code{diff}:

\\begin{verbatim}
diff : List String -> List String -> DiffRecord
diff u v =
    let
        a = commonInitialSegment u v
        b = commonTerminalSegment u v
        la = List.length a
        lb = List.length b
        x =  u |> List.drop la |> dropLast lb
        y = v |> List.drop la |> dropLast lb
    in
        DiffRecord a b x y
\\end{verbatim}

In an edit cycle, we need to update the current \\code{EditRecord}, which we do using \\code{Differ.update}.

$$
{\\bf Diff.update\\ } \\text{transformer editRecord text} \\longrightarrow \\text{newEditRecord}
$$

The \\code{Diff.update} function defined below breaks the \\code{text} into paragraphs, computes the \\code{diffRecord}, and returns an updated version of \\code{editRecord} by applying \\code{transformer} to $\\beta'$.

\\begin{verbatim}
update : (String -> String) -> EditRecord -> String -> EditRecord
update transformer editorRecord text =
    let
        newParagraphs =
            paragraphify text
        diffRecord =
            diff editorRecord.paragraphs newParagraphs
        newRenderedParagraphs =
            renderDiff transformer diffRecord editorRecord.renderedParagraphs
    in
        EditRecord newParagraphs newRenderedParagraphs
\\end{verbatim}

Here is how \\code{renderDiff}, which is used to update the \\code{editRecord}, is defined:

\\begin{verbatim}
renderDiff : (String -> String) -> DiffRecord -> List String -> List String
renderDiff renderer diffRecord renderedStringList =
  let
    ii = List.length diffRecord.commonInitialSegment
    it = List.length diffRecord.commonTerminalSegment
    initialSegmentRendered = List.take ii renderedStringList
    terminalSegmentRendered = takeLast it renderedStringList
    middleSegmentRendered = (renderList renderer) diffRecord.middleSegmentInTarget
  in
    initialSegmentRendered ++ middleSegmentRendered ++ terminalSegmentRendered
\\end{verbatim}


\\section{Status}

MiniLaTeX is now at version 2.1.  It includes the following.

\\begin{itemize}

\\item \\strong{Environments:}  \\italic{align, center, enumerate, eqnarray, equation, itemize, macros, tabular}. The environments  \\italic{theorem, proposition, corollary, lemma, definition} are handled by a default mechanism.

\\item \\strong{Macros}: \\italic{cite, code, ellie, emph, eqref, href, iframe, image, index, italic, label, maketitle, mdash, ndash, newcommand, ref, section, section*, strong, subheading, subsection, subsection*, subsubsection, subsubsection*, title, term, xlink, xlinkPublic}
\\end{itemize}

Most of the macro and environment renderers are in final or close to final form. A few, e.g. \\italic{tabular} need considerably more work, and a few more are dummies.



\\comment{ Article by Ilias: https://github.com/zwilias/elm-json/blob/master/src/Json/Parser.elm}


"""


wavePackets =
    """

\\title{Wave packets and the dispersion relation}

\\maketitle

\\tableofcontents

\\image{http://psurl.s3.amazonaws.com/images/jc/sinc2-bcbf.png}{Wave packet}{width: 250, float: right}


As we have seen with the sinc packet, wave packets can be localized in space.  A key feature of such packets is their \\italic{group velocity} $v_g$.  This is the velocity which which the "body" of the wave packet travels.  Now a wave packet is synthesized by superposing many plane waves, so the natural question is how is the group velocity of the packet related to the phase velocities of its constituent plane waves.  We will answer this first in the simplest possible situation -- a superposition of two sine waves.  Next, we will reconsider the case of the sinc packet.  Finally, we will study a more realistic approximation to actual wave packets which gives insight into the manner and speed with which wave packets change shape as they evolve in time.  We end by applying this to an electron in a thought experiment in which it has been momentarily confned to an atom-size box -- about one Angstrom, or $10^{-10}\\text{ meter}$.

\\section{A two-frequency packet: beats}

\\image{http://psurl.s3.amazonaws.com/images/jc/beats-eca1.png}{Two-frequency beats}{width: 350, float: right}

Consider a wave
$\\psi = \\psi_1 + \\psi_2$ which is the sum of two terms with slightly different frequencies.  If the waves are sound waves, then then what one will hear is a pitch that corresponding to the average of the two frequencies modulated in such a way that the volume goes up and down at a frequency corresponding to their difference.

Let us analyze this phenomenon mathematically, setting


\\begin{equation}
\\psi_1(x,t)  = \\cos((k - \\Delta k/2)x - (\\omega - \\Delta \\omega/2)t)
\\end{equation}

and

\\begin{equation}
\\psi_2(x,t)  = \\cos((k + \\Delta k/2)x - (\\omega + \\Delta \\omega/2)t)
\\end{equation}

By the addition law for the sine, this can be rewritten as

\\begin{equation}
\\psi(x,t) = 2\\sin(kx - \\omega t)\\sin((\\Delta k)x - (\\Delta \\omega)t)
\\end{equation}

The resultant wave -- the sum -- consists of of a high-frequency sine wave oscillating according to the average of the component wave numbers and angular frequencies, modulated by a cosine factor that oscillates according to the difference of the wave numbers and the angular frequencies, respectively.  The velocity associated to the high frequency factor is

\\begin{equation}
v_{phase} = \\frac{\\omega}{k},
\\end{equation}

whereas the velocity associated with the low-frequency factor is

\\begin{equation}
v_{group} = \\frac{\\Delta \\omega}{\\Delta k}
\\end{equation}

This is the simplest situation in which one observes the phenomenon of the group velocity.  Take a look at this \\href{http://galileo.phys.virginia.edu/classes/109N/more_stuff/Applets/wavepacket/wavepacket.html}{animation}.


\\section{Step function approximation}

We will now find an an approximation to

\\begin{equation}
\\psi(x,t) = \\int_{-\\infty}^\\infty a(k) e^{i(kx - \\omega(k)t)} dk
\\end{equation}

under the assumption that $a(k)$ is nearly constant over an interval from $k_0 -\\Delta k/2$ to $k_0 + \\Delta k/2$ and that outside of that interval it approaches zero at a rapid rate.  In that case the Fourier integral is approximated by

\\begin{equation}
 \\int_{k_0 - \\Delta k/2}^{k_0 + \\Delta k/2}  a(k_0)e^{i((k_0 + (k - k_0)x - (\\omega_0t + \\omega_0'(k - k_0)t))}dk,
\\end{equation}

where $\\omega_0 = \\omega(k_0)$ and $\\omega_0' = \\omega'(k_0)$.
This integral can be written as a product $F(x,t)S(x,t)$, where the first factor is "fast" and the second is "slow."  The fast factor is just

\\begin{equation}
F(x,t) = a(k_0)e^{ i(k_0x - \\omega(k_0)t) }
\\end{equation}

It travels with velocity $v_{phase} = \\omega(k_0)/k_0$.  Setting $k; = k- k_0$, the slow factor is

\\begin{equation}
S(x,t) = \\int_{-\\Delta k/2}^{\\Delta k/2} e^{ik'\\left(x - \\omega'(k_0)t\\right)} dk',
\\end{equation}

The slow factor be evaluated explicitly:

\\begin{equation}
I = \\int_{-\\Delta k/2}^{\\Delta k/2} e^{ik'u} dk' = \\frac{1}{iu} e^{ik'u}\\Big\\vert_{k' = - \\Delta k/2}^{k' = +\\Delta k/2}.
\\end{equation}

We find that

\\begin{equation}
I = \\Delta k\\; \\text{sinc}\\frac{\\Delta k}{2}u
\\end{equation}

where $\\text{sinc } x = (\\sin x )/x$.  Thus the slow factor is

\\begin{equation}
S(x,t) = \\Delta k\\, \\text{sinc}(  (\\Delta k/2)(x - \\omega'(k_0)t)  )
\\end{equation}


Putting this all together, we have

\\begin{equation}
\\psi(x,t) \\sim a(k_0)\\Delta k_0\\, e^{i(k_0x - \\omega(k_0)t)}\\text{sinc}(  (\\Delta k/2)(x - \\omega'(k_0)t)  )
\\end{equation}

Thus the body of the sinc packet moves steadily to the right at velocity $v_{group} = \\omega'(k_0)$


\\section{Gaussian approximation}

The approximation used in the preceding section is good enough to capture and explain the group velocity of a wave packet.  However, it is not enough to explain how wave packets change shape as they evolve with time.  To understand this phenomenon, we begin with  an arbitrary packet

\\begin{equation}
\\psi(x,t) = \\int_{\\infty}^\\infty a(k) e^{i\\phi(k)}\\,dk,
\\end{equation}

where $\\phi(k) = kx - \\omega(k)t$.  We shall assume that the spectrum $a(k)$ is has a maximum at $k = k_0$ and decays fairly rapidly away from the maximum.  Thus we assume that the Gaussian function

\\begin{equation}
a(k) = e^{ -(k-k_0)^2/ 4(\\Delta k)^2}
\\end{equation}

is a good approximation.  To analyze the Fourier integral

\\begin{equation}
\\psi(x,t) = \\int_{-\\infty}^{\\infty} e^{ -(k-k_0)^2/ 4(\\Delta k)^2} e^{i(kx - \\omega(k) t)},
\\end{equation}

we expand $\\omega(k)$ in a Taylor series up to order two, so that

\\begin{equation}
\\phi(k) = k_0x + (k - k_0)x - \\omega_0t - \\frac{d\\omega}{dk}(k_0) t- \\frac{1}{2}\\frac{ d^2\\omega }{ dk^2 }(k_0)( k - k_0)^2 t
\\end{equation}

Writing $\\phi(k) = k_0x - \\omega_0t + \\phi_2(k,x,t)$, we find that

\\begin{equation}
\\psi(x,t) = e^{i(k_0x - \\omega_0 t)} \\int_{-\\infty}^{\\infty} e^{ -(k-k_0)^2/ 4(\\Delta k)^2} e^{i\\phi_2(k,x,t)}.
\\end{equation}

Make the change of variables $k - k_0 = 2\\Delta k u$, and write $\\phi_2(k,x,t) = Q(u,x,t)$, where $Q$ is a quadratic polynomial in $u$ of the form $au + b$. One finds that

\\begin{equation}
  a = -(1 + 2i\\alpha t  (\\Delta k)^2),
\\end{equation}

where

\\begin{equation}
\\alpha = \\frac{ d^2\\omega }{ dk^2 }(k_0)
\\end{equation}

One also finds that

\\begin{equation}
  b = 2i\\Delta k(x - v_g t),
\\end{equation}

where $v_g = d\\omega/dk$ is the group velocity.  The integral is a standard one, of the form

\\begin{equation}
\\int_{-\\infty}^\\infty e^{- au^2 + bu} = \\sqrt{\\frac{\\pi}{a}}\\; e^{ b^2/4a }.
\\end{equation}

Using this integral  formula and the reciprocity $\\Delta x\\Delta k = 1/2$, which we may take as a definition of $\\Delta x$, we find, after some algebra, that

\\begin{equation}
\\psi(x,t) \\sim A e^{-B} \\,e^{i(k_0 - \\omega_0t)}
,
\\end{equation}

where

\\begin{equation}
A = 2\\Delta k \\sqrt{\\frac{\\pi}{1 + 2i\\alpha \\Delta k^2 t}}
\\end{equation}

and

\\begin{equation}
B = \\frac{( x-v_gt )^2 (1 - 2i\\alpha \\Delta k^2 t)}{4\\sigma^2}
\\end{equation}

with

\\begin{equation}
\\sigma^2 = \\Delta x^2 + \\frac{\\alpha^2 t^2}{4 \\Delta x^2}
\\end{equation}

Look at the expression $B$. The first factor in the numerator controls the motion of motion of the packet and is what guides it to move with group velocity $v_g$.  The second factor is generally a small real term and a much larger imaginary one, and so only affects the phase.  The denominator controls the width of the packet, and as we can see, it increases with $t$ so long as $\\alpha$, the second derivative of $\\omega(k)$ at the center of the packet, is nonzero.

\\section{The electron}

Let us apply what we have learned to an electron which has been confined to a box about the size of an atom, about $10^{-10}$ meters. That is, $\\Delta x \\sim 10^{-10}\\text{ m}$.  The extent of its wave packet will double when

\\begin{equation}
\\frac{\\alpha^2 t^2}{4 \\Delta x^2} \\sim \\Delta x^2,
\\end{equation}

that is, after a time

\\begin{equation}
t_{double} \\sim \\frac{\\Delta x^2}{\\alpha}
\\end{equation}

The dispersion relation for a free particle is

\\begin{equation}
  \\omega(k) = \\hbar \\frac{k^2}{2m},
\\end{equation}

so that $\\alpha = \\hbar/m$.  Then

\\begin{equation}
t_{double} \\sim \\frac{m}{h}\\, \\Delta x^2 .
\\end{equation}

In the case of our electron, we find that $t_{double} \\sim 10^{-16}\\,\\text{sec}$.

\\section{ Code}



\\begin{verbatim}
# jupyter/python

matplotlib inline

# code for sinc(x)
import numpy as np
import matplotlib.pyplot as plt

# sinc function
x = np.arange(-30, 30, 0.1);
y = np.sin(x)/x
plt.plot(x, y)

# beats
x = np.arange(-50, 250, 0.1);
y = np.cos(0.5*x) + np.sin(0.55*x)
plt.plot(x, y)
\\end{verbatim}



\\section{References}

\\href{https://www.eng.fsu.edu/~dommelen/quantum/style_a/packets.html}{Quantum Mechanics for Engineers: Wave Packets}

\\href{http://users.physics.harvard.edu/~schwartz/15cFiles/Lecture11-WavePackets.pdf}{Wave Packets, Harvard Physics}

\\href{http://ocw.mit.edu/courses/nuclear-engineering/22-02-introduction-to-applied-nuclear-physics-spring-2012/lecture-notes/MIT22_02S12_lec_ch6.pdf}{Time evolution in QM - MIT}

"""


weatherApp =
    """
\\section{Weather App}

\\image{http://noteimages.s3.amazonaws.com/jim_images/weatherAppColumbus.png}{}{float: right, width: 250}

In this section we will learn how to write an app that displays information about the weather  in any city on planet earth.   The data comes from a web server at \\href{http://openweathermap.org/}{openweathermap.org}; to access it, you will need a free API key, which is a long string of letters and numbers  that looks like \\code{a23b...ef5d4} and which functions as a kind password. To get an API key, follow this \\href{http://openweathermap.org/price}{link}.  Once you have an API key, you can try out a working copy of the app at \\href{https://jxxcarlson.github.io/app/weather.html}{jxxcarlson.github.io}.

\\subheading{Framing Main}

We will build the app in a series of steps.  The first step is to build a skeleton that has all the needed structural parts, e.g, the view and update functions.    Part of this "framing" step is to define the data types that the app will use --- \\code{Model} and its various parts, and \\code{Msg}, a union type which determines which messages can be sent to the Elm Runtime.  Let's begin with \\code{main}, which looks like this:

\\begin{verbatim}
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
\\end{verbatim}

This is the structure, \\code{Html.program}, is used by $99\\%$ of all Elm programs.  It is a a record with four fields, the init, view, and update functions, and subscriptions, which will eventually be used to add date and time to the app. The init, view and update functions all work  with the model, so let's discuss that next.

\\subheading{Model}

Every model has a type, and that type dictates what the model is able to represent.  In our case the \\code{Model} type, displayed below,  is a record with five fields: one for weather data, one for messages for the user, one for the location whose weather we retrieve, one for the API key discussed above, and one for the internet address of the server.  The first field has a special type which we discuss in a moment, while the other fields are strings.


\\begin{verbatim}
type alias Model =
    { weather : Maybe Weather
    , message : String
    , location : String
    , apiKey : String
    , serverAddress : String
    }
\\end{verbatim}

The type of the weather field has the form

\\begin{verbatim}
Maybe Weather = Nothing | Just Weather
\\end{verbatim}

This means that a value of type \\code{Maybe Weather} can be either \\code{Nothing}, or a value of type \\code{Just Weather}.  The  first option handles the case in which  the app has not requested information from the server, has requested information but has received no reply, has requested information but received an error message, or, finally has received garbled information.  These are all very real possibilities, and in those cases, we literally know \\code{Nothing}.

In the case of valid weather information, \\code{weather} field has type \\code{Just Weather}, where \\code{Weather} is the record type listed below. The first, \\code{id}, is an integer which identifies the weather information in the openweather.org database.  We won't use it now.  The next, \\code{location}, is a string which in our examples is a city name, e.g., "London."  The third, \\code{main}, is the "main" weather information for the given location.

\\begin{verbatim}
type alias Weather =
    { id : Int
    , name : String
    , main : Main
    }
\\end{verbatim}

And what is the value of the field \\code{main}?  Well, it is a something of type \\code{Main}.  While we seem to be opening up a series of Russian dolls, this is the last data structure that we have to deal with.  \\code{Main} is a record  with five fields of type \\code{Float}

\\begin{verbatim}
type alias Main =
    { temp : Float
    , humidity : Float
    , pressure : Float
    , temp_min : Float
    , temp_max : Float
    }
\\end{verbatim}

\\subheading{Filling out Main}

The code discussed so far is still not enough to define an app that will run, even if it does nothing.  To get to this point, we must implement the following functions and types:

\\begin{enumerate}
\\item \\code{init}, which sets jup the initial model.
\\item \\code{Msg} The type messages the app can receive.
\\item \\code{subscriptions}. There aren't any, but this has to be defined.
\\item \\code{view} and some style information to make the view look good.
\\item \\code{update}
\\end{enumerate}

Take a look at the Ellie below and run it to see if it works.  Then come back and we will go through the list above.  Once this is done, we can move on to making the app actaully do something.

\\ellie{9CKgm5CQGa1/0}{Skeleton app}

\\subheading{Finishing the skeleton}

Let's finish the skeleton by filling in the items listed above.

\\subheading{Init and Msg}

\\begin{verbatim}
init : ( Model, Cmd Msg )
init =
    ( { weather = Nothing
      , message = "app started"
      , location = "london"
      , apiKey = ""
      }
    , Cmd.none
    )
\\end{verbatim}


Below is  \\code{init}. It is a value of type \\code{(Model, Cmd Msg)}.  The \\code{Msg} type
is defined this way:

\\begin{verbatim}
type Msg = NoOp
\\end{verbatim}

We will have other Msg's later.  But when staring out, it is worth having a kind of "zero" in the world of messages -- a message which corresponds to "no operation."


\\subheading{Subscriptions}

We need to define \\code{subscription} even if there are no subscriptions to external data sources. Let's do it like this:

\\begin{verbatim}
subscriptions model =
    Sub.none
\\end{verbatim}

\\subheading{Update}

The update function handles our \\code{NoOp} message:

\\begin{verbatim}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
\\end{verbatim}

Later, the case statment will be more complex, with one
 clause for each \\code{Msg} type.


\\subheading{View}

\\image{http://noteimages.s3.amazonaws.com/jim_images/weatheApp-0.png}{}{float: right, width: 150}

The \\code{view} function represents the state of the \\code{Model}
to the outside world.  In the case at hand, it just displays a grey box
as in the image on the right.

\\begin{verbatim}
view : Model -> Html Msg
view model =
    div [ mainStyle ]
        [ div [ innerStyle ]
            [ text "Weather App"
            ]
        ]
\\end{verbatim}

\\subheading{Style}

To set the stage for our working app, we use a small bit of styling:

\\begin{verbatim}
mainStyle =
    style
        [ ( "margin", "15px" )
        , ( "margin-top", "20px" )
        , ( "background-color", "#eee" )
        , ( "width", "200px" )
        ]

innerStyle =
    style [ ( "padding", "15px" ) ]
\\end{verbatim}


\\image{http://noteimages.s3.amazonaws.com/jim_images/weatherApp-2.png}{}{float: right, width: 200}


\\subsection{Getting the weather}



Let's now work to make the app retrieve weather data.  There is a cycle of events which makes this happen.  First, the user clicks on the "Get weather" button, which is defined by

\\begin{verbatim}
button
   [ onClick GetWeather ]
   [ text "Get weather" ]
\\end{verbatim}

The \\code{onClick} action causes the message \\code{GetWeather} to be sent.  The \\code{update} function listed below receives this message, matches it using its \\code{case msg of} statement to the function call  \\code{getWeather model}, and executes that call.

\\begin{verbatim}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetWeather ->
            ( model, getWeather model )
        NewWeather (Ok newData) ->
            ( { model | weather = Just newData,
                        message = "Successful request" },
                Cmd.none
             )
        NewWeather (Err error) ->
            ( { model | message = "Error" }, Cmd.none )

\\end{verbatim}

Let's look at the code for \\code{getWeather}.

\\begin{verbatim}
getWeather : Model -> Cmd Msg
getWeather model =
    Http.send NewWeather (dataRequest model)
\\end{verbatim}

When this function call is executed the following happen.  (1)  The request \\code{ dataRequest model} is made; (2)  Moments later the server responds with its \\code{reply}, also a string. This is a string which re[renset sdh dtdata  which is just a string.  It represent the if  (3) send the message \\code{NewWeather reply}, (4) the update function processes that message.  The message can be of two kinds.  If the request is successful, it is of form \\code{Ok newData} where \\code{NewData} carries the information sent by the server.  If the request is not successful, the reply has the form \\code{Error error}, where \\code{error} carries information about the error.

Let's  look at the code for \\code{dataRequest} listed below                                              .  The function \\code{Http.get} takes two arguments.  The first is the function call \\code{url model}, which yields a string to be sent to the server m  It carries information such as the "address" of the server, the city whose weather we want to know about, and the API key that the server requires to grant access.  The second argument is a JSON decoder.  This is a black box which will translate the information send by the server into a form understood by Elm.

\\begin{verbatim}
dataRequest model =
    Http.get (url model) weatherDecoder
\\end{verbatim}

The code for the \\code{url} function simply puts information already present in the model into the form needed by the server:

\\begin{verbatim}
url model =
  model.urlPrefix ++ model.location ++ "&APPID=" ++ model.apiKey
\\end{verbatim}




\\ellie{chqbtP2Kfa1/1}

\\section{IIIIIII}

\\image{http://noteimages.s3.amazonaws.com/jim_images/weatherApp-1a.png}{}{float: right, width: 250}


\\ellie{8Wrq8PbCDa1/1}

\\subsection{A little more advanced}

\\ellie{7t43vKJnda1/5}


"""


nongeodesic =
    """



 \\title{Non-geodesic variations of Hodge structure of maximum dimension}

  \\author{James A. Carlson and Domingo Toledo}

  \\date{November 1, 2017}




  \\maketitle

\\tableofcontents


  \\begin{abstract}
  There are a number of examples of variations of Hodge structure of maximum dimension.  However, to our knowledge, those that are global on the level of the period domain are totally geodesic subspaces that arise from an orbit of a subgroup of the group of the period domain. That is, they are defined by Lie theory rather than by algebraic geometry.  In this note, we give an example of a variation of maximum dimension which is nowhere tangent to a geodesic variation.  The period domain in question, which classifies weight two Hodge structures with $h^{2,0} = 2$ and $h^{1,1} = 28$, is of dimension $57$. The horizontal tangent bundle has codimension one, thus it is an example of a holomorphic contact structure, with local integral manifolds of dimension 28. The group of the period domain is $SO(4,28)$, and one can produce global integral manifolds as orbits of the action of subgroups isomorphic to $SU(2,14)$.  Our example is given by the variation of Hodge structure on the second cohomology of weighted projective hypersurfaces of degree $10$ in a weighted projective three-space with weights
  $1, 1, 2, 5$
  \\end{abstract}

  \\section{Introduction}
  \\label{sec:introduction}


$$
\\newcommand{\\C}{\\mathbb{C}}
\\newcommand{\\P}{\\mathbb{P}}
\\newcommand{\\Q}{\\mathbb{Q}}
\\newcommand{\\R}{\\mathbb{R}}
\\newcommand{\\bH}{\\mathbf{H}}
\\newcommand{\\hodge}{\\mathcal{H}}
\\newcommand{\\surfs}{\\mathcal{S}}
\\newcommand{\\var}{\\mathcal{V}}
\\newcommand{\\Hom}{\\text{Hom}}
$$

  Period domains $D = G/V$ for $G$ a (semi-simple, adjoint linear Lie group with a compact Cartan subgroup $T\\subset G$ and $V$ the centralizer of a sub-torus of $T$) occur in many interesting situations.  It is known that there is a unique maximal compact subgroup $K\\subset G$ containing $V$,
  so that there is a fibration
  \\begin{equation}
  \\label{eq:fibration}
  K/V \\longrightarrow  G/V \\buildrel \\pi \\over\\longrightarrow  G/K
  \\end{equation}
  of the homogeneous complex manifold $G/V$ onto the symmetric space $G/K$ with fiber the homogeneous projective variety $K/V$.  The tangent bundle $TD$ has a distinguished \\emph{horizontal sub-bundle} $T_h D$ (also called the \\emph{infinitesimal period relation}). It is a sub-bundle of the differential-geometric horizontal bundle (the orthogonal complement of the tangent bundle to the fibers). It usually, but not always a proper sub-bundle. When it is a proper sub-bundle, it is not integrable.  Typically, successive brackets of vector fields in $T_hD$ generate all of $ TD$.  We are interested in the case where the symmetric space $G/K$ is \\emph{not} Hermitian symmetric.  In that case, the complex manifold $D$ admits invariant pseudo-K\\"ahler metrics, but no invariant K\\"ahler metric.

  These manifolds were introduced by Griffiths as a category of manifolds that contains the classifying spaces  of Hodge structures.  For example, if $(H, \\left< \\ , \\ \\right>)$ is a real vector space of dimension $2p+q$ with a symmetric bilinear form of signature $2p,q$,
  the manifolds $SO(2p,q)/U(p)\\times SO(q)$ classify Hodge decompositions  of weight two. Thus, we
  have a direct sum decomposition

  \\begin{equation}
  \\label{ eq:hodgedecomp}
  H^\\C = H^{2,0}\\oplus H^{1,1}\\oplus H^{0,2}
  \\end{equation}

  with Hodge numbers (dimensions)  $h^{2,0} = h^{0,2} = p $, $h^{1,1} = q$, and polarized by $\\left< \\ , \\ \\right>$: The real points of $H^{2,0}\\oplus H^{0,2}$ form a maximal positive subspace, $H^{1,1}$ is the complexification of its  orthogonal complement
  (a maximal negative subspace), and so $(H^{2.0})^\\perp = H^{2,0}\\oplus H^{1,1}$.   Therefore the filtration
  \\begin{equation}
  \\label{eq:hodgefiltration}
  H^{2,0}\\subset (H^{2,0})^\\perp \\subset H^\\C
  \\end{equation}
  of $H^\\C$ is the same as the Hodge filtration.  Therefore $H^{2,0}$ determines the Hodge filtration, hence the Hodge decomposition.  Note that $\\left< u,\\overline{v} \\right>$ is a positive Hermitian inner product on $H^{2,0}$

  The special orthogonal group of $\\left< \\ ,\\ \\right>$, isomorphic to $SO(2p,q)$, acts transitively on the choices of $H^{2,0}$, and the subgroup fixing one choice is isomorphic to $U(p)\\times SO(q)$.
  Thus, the homogeneous complex manifold $D = SO(2p,q)/U(p)\\times SO(q)$ classifies polarized Hodge structures on a \\emph{fixed} vector space $(H, \\left< \\ ,\\  \\right>)$.  Over $D$, there are tautological Hodge bundles $\\hodge^{2,0},\\hodge^{1,1},\\hodge^{0,2}$.  The tangent bundle $TD$ and horizontal sub-bundle are

  \\begin{equation}
  \\label{eq:hodgebundles}
  TD = Hom_{\\left< \\ ,\\ \\right>}(\\hodge^{2,0},\\hodge^{1,1}\\oplus \\hodge^{0,2}),\\ \\ T_hD = Hom(\\hodge^{2,0},\\hodge^{1,1}),
  \\end{equation}

  where $Hom_{\\left< \\ ,\\ \\right>}$ means homomorphisms $X$ which  preserving $\\left< \\  , \\  \\right>$ infinitesimally, that is, $\\left< Xu,v \\right> + \\left< u,Xv \\right> = 0$ for all $u,v \\in H^{2,0}$.  If $X:H^{2,0}\\to H^{1,1}$ this condition is vacuous, since $\\left< H^{2,0},H^{1,1} \\right> = 0$. Therefore $Hom_{\\left< \\ ,\\ \\right>}(\\hodge^{2,0},\\hodge^{1,1}) = Hom(\\hodge^{2,0},\\hodge^{1,1})$.

  Whenever $p > 1$, the horizontal tangent bundle is a proper sub-bundle of the  tangent bundle.  The first interesting case is $p = 2$. If in addition $q = 2r$ is even, then the horizontal distribution locally a contact distribution, i.e., is the null space of a form $\\omega = dz - (x_1 dy_1 + \\cdots + x_r dy_r)$ in suitable local coordinates $(x,y,z)$.  Our example of weighted hypersurfaces yields a variation of Hodge structure of this type.

  \\subsection{Construction of horizontal maps}
  \\label{subsec:construction}


  The  two main sources of horizontal holomorphic maps to period domains are

\\emph{Totally geodesic maps}:  these come from Lie group theory, as orbits of suitable Lie subgroups of $G$.  For example, for the domains $SO(2p,2q)/U(p)\\times SO(2q)$, we can put a complex structure $J$  on the underlying $\\R$-vector space $H$, compatible with $< \\ , \\ >$.  Let $H^+, H^-$ denote the underlying real spaces of $H^{2,0}\\oplus H^{0,2}$ and $H^{1,1}$ respectively. Consider the variation in which all $H^+$ are $J$-invariant.  This gives an embedding

     \\begin{equation}
  \\label{ }
  SU(p,q)/S(U(p)\\times U(q)) \\buildrel F \\over\\longrightarrow  SO(2p,2q)/U(p) \\nonumber\\times SO(2q)
  \\end{equation}

  of the Hermitian symmetric space $D_1$ for $SU(p,q)$ in the domain $D$.     Since $H^+$ always remains $J$-invariant, the tangent vector to its motion, an element of $Hom(H^+,H^-)$ commutes with $J$.  Let $V\\subset H^{1,1}$ be the space of $(1,0)$-vectors for $J$, that is, $V = \\{X - iJX \\ | X\\in H^{1,1}\\}$.   Then


\\begin{equation}
  dF:TD_1 \\to Hom(H^{2,0},V) \\subset Hom(H^{2,0},H^{1,1} )= T_hD \\nonumber
\\end{equation}

in particular $F$ is horizontal and holomorphic.


\\emph{Periods of  families of algebraic varieties}  This may be called the geometric method.  We proceed to explain it by describing the special case of  $SO(2p,2q)$:}



   Let $\\surfs \\to B$ be smooth algebraic family of smooth projective algebraic surfaces over a smooth connected algebraic base $B$, fix a base point $b_0\\in B$, and fix $(H, \\left<\\ , \\ \\right>)$ to be the pair ($H^2(\\surfs_{b_0},\\R)_{prim}$, intersection form).  For any $b\\in B$ and a path $\\lambda$ from $b_0$ to $b$, there is an isomorphism $\\lambda^\\#:H^2(\\surfs_b)\\to H^2(\\surfs_{b_0})$, where different paths give different isomorphisms related by an element of the image of the monodromy representation $\\rho:\\pi_1(B,b_0) \\to Aut(H^2_{prim}(\\surfs_{b_0}))$. The \\emph{period map} $F$  is defined by the rule:  $F(b)$ is the Hodge structure $\\lambda^\\#$(Hodge structure on $H^2(\\surfs_b)$).  In this way, $F(b)$ is a Hodge structure on a fixed vector space, hence an element of $D$, well defined up to the action of the monodromy group.  We could look at this as a function of $b$ and $\\lambda$, in which case we are lifting $F$ to a map $\\widetilde{F}$ on a covering space of $B$.   Thus we have two equivalent formulations $F, \\widetilde{F}$ of the period map related as follows:
    \\begin{eqnarray}
  \\begin{array}{ccc}
  \\label{eq:periodmaps}
      \\widetilde{B} &  \\buildrel \\widetilde{F} \\over\\longrightarrow  & D  \\\\
  {p}\\Big\\downarrow & & \\Big\\downarrow   \\\\
  B & \\buildrel F\\over \\longrightarrow & \\Gamma\\backslash D
  \\end{array}
  \\end{eqnarray}
  where $p:\\widetilde{B}\\to B$ is the covering corresponding to the kernel of $\\rho$ and  $\\Gamma$ is a suitable monodromy group (containing the image of $\\rho$).     Locally, the two maps $F, \\widetilde{F}$ are the same, except when $F(b)$ is fixed by some non-identity element of $\\Gamma$.


  Griffiths showed that \\emph{$F$ is holomorphic and horizontal}, in other words, $d\\widetilde{F}:T\\widetilde{B}\\to F^*T_h D \\subset T D$.  Under suitable assumptions, the closure  $\\overline{F(B)}$ is an analytic subvariety of $\\Gamma\\backslash D$, hence is a closed \\emph{horizontal analytic subvariety} of $\\Gamma\\backslash D$.

  \\subsection{A concrete example}

  The preceding discussion can be applied to the family of smooth hypersurfaces in $\\P^3$ of a fixed degree $d$.  In order to get non-constant variations and for the period domain not to be Hermitan symmetric we need to take $d\\ge 5$.

  For $d=5$ we have that the Hodge numbers are $(4,44,4)$, hence $D = SO(8,44) / U(4)\\times SO(44)$ has dimension $182$, the horizontal tangent space has dimension $176$ and the maximum dimension of an integral submanifold is $88$, the dimension of the horizontal $SU(4,22)$ orbit, see \\cite{carlson}

  We therefore find two horizontal maps:
  \\begin{itemize}
    \\item Horizontal $SU(4,22)$ orbits of maximum dimension $88$.
    \\item Periods of quintic surfaces, a \\emph{maximal} integral manifold, see \\cite{carlsondonagi} of dimension $40$ (the dimension of the moduli space of quintic surfaces).
  \\end{itemize}

  In general, period domains, can have maximal integral manifolds of many different dimensions. Hypersurfaces generally yield integral manifolds of rather small dimension compared to the the maximum possible.  We would like to see geometric  examples of maximum, or close to maximum, dimension that come from geometry as opposed to Lie theory.   Hypersurfaces in weighted projective spaces provide such examples.

  \\section{The example}
  \\label{sec:example}

  Let us consider the weighted projective space $\\P(1,1,2,5)$ with coordinates $x_1,x_2,x_3,x_4$ with weights $1,1,2,5$ respectively.  One may think of $\\P(1,1,2,5)$ as the quotient of $\\C^4$ by the $\\C^*$-action  $\\lambda\\in \\C^*$ which acts by
  \\begin{equation}
  \\label{eq:weightaction}
  \\lambda \\cdot (x_1,x_2,x_3,x_4) \\longrightarrow (\\lambda x_1,\\lambda x_2, \\lambda^2 x_3, \\lambda^5 x_4)
  \\end{equation}
  A weighted homogeneous polynomial of degree $d$  is a linear combination of monomials
  \\begin{equation}
  \\label{eq:monomials}
  x_1^{k_1} x_2^{k_2} x_3^{k_3}x_4^{k_4} \\text{ of total weighted degree } d = k_1 + k_2 + 2 k_3 + 5 k_4
  \\end{equation}

  For fixed $d$, the collection of weighted polynomials of degree $d$ forms a vector space that we will denote $S_d(1,1,2,5)$, or, simply $S_d$.   The direct sum $S(1,1,2,5) = \\oplus_d S_d(1,1,2,5)$ is the algebra of weighted homogeneous polynomials.

  Any $f\\in S_d$ defines a subvariety $V_f\\subset P(1,1,2,5)$, namely $V_f = \\{(x_1:x_2:x_3:x_4) | f(x_1,x_2,x_3,x_4) = 0 \\}$.  If the only common solution of

  \\begin{equation}
  \\frac{\\partial f}{\\partial x_1} = 0,\\dots, \\frac{\\partial f}{\\partial x_4} =0  \\nonumber
  \\end{equation}

  is  $(0,0,0,0)$, then $V_f$ is called a \\emph{quasi-smooth} subvariety.  It is smooth except possibly for quotient singularities. Topologically it is a rational homology manifold, and in particular satisfies Poincar\\'e duality over $\\Q$.  Its second cohomology has a pure Hodge structure of weight two, polarized by the intersection form.

  Fix $d$ and let $S_d^0\\subset S_d$ denote the set, possibly empty, of all $f\\in S_d$ for which $V_f$ is quasi-smooth.  For example, if $f\\in S_4$, then no monomial in  $f$ can contain the variable $x_4$ of weight $5$, so $\\frac{\\partial f}{\\partial x_4} = 0$ for all $f\\in S_4$.  Therefore $S_4^0 =\\emptyset$ since $(0:0:0:1)$ is a singular point of all $f\\in S_4$.  On the other hand, a polynomial  in $S_d$ is a sum of powers of \\emph{all}  of the variables defines a Fermat hypersurface.   These are always quasi-smooth.  In our case, one has the Fermat surface

  \\begin{equation}
  \\label{eq:fermat}
  f_0 (x_1,x_2,x_3,x_4) = x_1^{10} + x_2^{10}  + x_3^5 + x_4^2 \\in S_{10}^0,
  \\end{equation}

  It has a rich structure, and, in particular, is double cover of  the 2-dimensional weighted projective plane with weights $1, 1, 2$, branched over a curve of degree ten.

  The complement $\\Delta_d = S_d \\setminus S_d^0$ is a subvariety of $S_d$.  It is a proper subvariety if $S_d^0\\ne \\emptyset$.


  Assume $S_d^0\\ne\\emptyset $.  Then $\\Delta_d$ has complex codimension $1$ in $S_d$. Consequently, $S_d^0$ is connnected and we obtain a topologically locally trivial fibration $\\var\\to S_d^0$ where the fiber over $f$ is the variety $V_f$:
  \\begin{eqnarray}
  \\label{eq:universalfamily}
  \\begin{array}{ccc}
  \\var = \\{(f,x) | f(x) = 0\\} & \\subset  & S_d^0 \\times \\P(1,1,2,5) \\\\
  \\Big\\downarrow& &\\Big\\downarrow \\\\
  S_d^0  & = & S_d^0
  \\end{array}
  \\end{eqnarray}

  Fix a base point  $f_0\\in S_d^0$.  Then there  is a monodromy representation $\\rho:\\pi_1(S_d^0,f_0) \\to Aut(H^2(V_{f_0}))$, where $Aut$ is the group of automorphisms respecting all topological structures, in particular, the intersection form.  As $f$ varies, we transport the Hodge structure on $H^2(V_f,\\C)_{prim} = H^{2,0}(V_f)\\oplus H^{1,1}(V_f)_{prim} \\oplus H^{0,2} (V_f)$ to $H^2(V_{f_0})_{prim}$, as explained in \\S \\ref{sec:introduction}, thus obtaining a point $F(f)\\in D$, well defined up to the action of the image of $\\rho$, where $D$ is the classifying space of Hodge structures on $H^2(V_{f_0})_{prim}$.   This defines   holomorphic period maps as in (\\ref{eq:periodmaps}), namely


  \\begin{eqnarray}
  \\begin{array}{ccc}
  \\label{eq:universalperiodmaps}
  \\widetilde{S_{d}^0} &  \\buildrel \\widetilde{F} \\over\\longrightarrow  & D  \\\\
  {p}\\Big\\downarrow & & \\Big\\downarrow   \\\\
  S_{d}^0 & \\buildrel F\\over \\longrightarrow & \\Gamma\\backslash D
  \\end{array}
  \\end{eqnarray}



  where $\\Gamma$ denotes the image of the monodromy representation $\\rho$, and
  which is \\emph{horizontal} in the sense that

  \\begin{equation}
  d\\widetilde{F} : T \\widetilde{S}_d^0 \\longrightarrow  \\widetilde{F}^* T_hD.
  \\end{equation}

  We  must look carefully at some local properties of the period map $F$.   Let $U$ be a simply connected neighborhood of the base point $f_0$.  The inverse image of $U$ in $\\widetilde{S^0_d}$
  is a disjoint union of open sets isomorphic to $U$.  On such a  component of the inverse image, we can replace the  map $\\widetilde{F}$ of (\\ref{eq:universalperiodmaps}) by its restriction to a that connected component.  Identifying it with $U$, we may replace (\\ref{eq:universalperiodmaps}) by the simpler diagram
  \\begin{eqnarray}
  \\begin{array}{ccc}
  \\label{eq:localuniversalperiodmaps}
  &  & D  \\\\
   &\\buildrel \\widetilde{F}  \\over \\nearrow & \\Big\\downarrow   \\\\
  U & \\buildrel F\\over \\longrightarrow & \\Gamma\\backslash D
  \\end{array}
  \\end{eqnarray}
  Thus the period map $F$ to $\\Gamma\\backslash D$ is \\emph{locally liftable} to $D$.  This is only an issue in the presence of fixed points.


  Our example of a horizontal non-geodesic $V\\subset \\Gamma\\backslash D$ will be $\\overline{F(S_d^0)}$, the closure of the image of $F$, for suitable $d$.   We proceed to the necessary computations.


  \\subsection{The Jacobian Ring}
  \\label{subsec:jacobianring}

  First of all,  choose $d = 10$, and  consider the space $S_{10}(1,1,2,5)$ of weighted homogeneous polynomials of degree $10$ with weights $(1,1,2,5)$.  Some computer experimentation led us to this choice. As noted above, the \\lq\\lq Fermat hypersurface\\rq\\rq  $V_{f_0}$ is defined by an element of $S_{10}$, and so  $S_{10}^0 \\ne\\emptyset$.
  Given $f\\in S_{10}^0$, let

\\begin{enumerate}

\\item $J(f)\\subset S$ denote the \\emph{Jacobian ideal of $f$}, namely the ideal generated by the partial derivatives of $f$.

\\item $R(f) = S/J(f)$ be the \\emph{Jacobian ring} of $f$.

\\end{enumerate}



  The Hodge decomposition and the differential of the period map have very explicit descriptions in terms of the graded ring $R(f)$ for $f\\in S_{10}^0$.  Since the dimensions of the graded components $R_k(f)$  are independent of $f$, we often write simply $R_k$ for $R_k(f)$.

\\begin{proposition}
\\label{prop:jacobiancomputations} Let $f\\in S_{10}^0$ and let $J$ and $R$ be as just defined.  Then


\\begin{enumerate}

\\item $R_1 \\cong H^{2,0}$

\\item $R_{11} \\cong H^{1,1}$

\\item $R_{21}\\cong H^{0,2}$

\\item $R_{22}\\cong \\C$

\\item $R_k = 0$ for $k>22$


\\item For $0\\le i \\le 22$, the pairing $R_i\\otimes R_{22-i}\\to R_{22}$ is non-degenerate.


\\end{enumerate}
\\end{proposition}

    \\begin{proof}
   Statements of this type for projective hypersurfaces are consequences of the Griffiths residue calculus.  The analogous statements  for weighted projective hypersurfaces are proved in Theorem 1 of \\cite{steenbrink} and in   \\S4.3 of  \\cite{dolgachev}.
    \\end{proof}


Applying the above to our situation, and using the polynomial $f_0$ to do computations,
we find

\\begin{lemma}
\\label{lem:dimensions}

\\begin{enumerate}
    \\item $h^{2,0} =2$, $h^{1,1} = 28$, $h^{0,2} = 2$
    \\item $D = SO(4,28) /U(2) \\times SO(28)$
    \\item $D$ has dimension $57$.
   \\item  The horizontal sub-bundle $T_h D = Hom(\\hodge^{2,0},\\hodge^{1,1})$ has fiber dimension $56$, hence is a holomorphic contact structure on $D$.

\\end{enumerate}

\\end{lemma}


\\strong{Proof}

   Since the Hodge numbers are independent of $f$, we can compute them for $f_0$.  Using  Proposition \\ref{prop:jacobiancomputations}, this is the same as computing the spaces $R_k(f_0)$, which amounts to a straightforward exercise of counting monomials.  First of all, $J$ is the ideal generated by $x_1^9,x_2^9, x_3^4,x_4$.  We find that

\\begin{enumerate}

\\item $R_1 = S_1 = \\left< x_1,x_2 \\right> $ is the vector space with basis $x_1,x_2$, so that  $h^{2,0} = h^{0,2} = 2$.

\\item $R_{11}$: to find a basis for this space, list all monomials that do not contain any of the above generators of $J$.  In particular, $x_4$ does not appear, so a basis consists of monomials in $x_1,x_2,x_3$ that do not contain $x_1^9, x_2^9,x_3^4$.  These can be conveniently grouped by powers of $x_3$:

\\item $G_3 = \\left< x_1^ix_2^{5-i}x_3^3 | i = 0,\\dots 5 \\right>$ is six-dimensional

    \\item $G_2 = \\left< x_1^ix_2^{7-i}x_3^2 | i = 0,\\dots 5 \\right>$ is eight-dimensional

    \\item $G_1 = \\left< x_1^ix_2^{9-i}x_3 | i = 1,\\dots 8 \\right>$ is eight-dimensional

    \\item $G_0 = \\left< x_1^ix_2^{11-i} | i = 3,\\dots 8 \\right>$  is six-dimensional


\\end{enumerate}

\\smallskip

  Therefore $\\dim R_{11} = h^{1,1} = 28$

It follows that $D$ classifies polarized Hodge structures with Hodge numbers $2,28,2$.  From the discussion in the introduction, it follows that $D = SO(4,28)/U(2)\\times SO(28)$, which has dimension $57$ and  its  sub-bundle $T_hD = Hom(\\hodge^{2,0},\\hodge^{1,1})$ has fiber dimension $h^{2,0}h^{1,1} = 56$.  The easiest way to visualize $D$, and to see its dimension and the structure of the horizontal sub-bundle,  is to use its fibration (\\ref{eq:fibration}) over the symmetric space.  In this case the symmetric space has real dimension $4\\cdot 28$ and the fiber  is a projective line:

      \\begin{eqnarray}
      \\label{eq:fibrationD}
    \\begin{array}{ccc}
  SO(4)/U(2) & \\longrightarrow & SO(4,28)/ U(2)\\times SO(28) \\\\
  & & \\Big\\downarrow {\\pi}      \\\\
  & &  SO(4,28) / S(O(4)\\times O(28))
  \\end{array}
  \\end{eqnarray}


  It is easy to see that $d\\pi$ maps the fibers of $T_h D$ isomorphically (as real vector spaces) to the tangent spaces to the symmetric space. Thus $T_hD$ coincides, in this case, with the differential-geometric horizontal bundle.

To see that $T_hD$ is a holomorphic contact structure, recall the identification (\\ref{eq:hodgebundles}), $TD \\cong Hom_{\\left< \\ , \\  \\right>}(\\hodge^{2,0},\\hodge^{1,1}\\oplus\\hodge^{0,2})$.  Under this identification, $T_hD$ is identified with $Hom(\\hodge^{2,0},\\hodge^{1,1})$ as the kernel of the projection to $Hom_{< \\ , \\  >}(\\hodge^{2,0},\\hodge^{0,2})$.   Since
  $Hom_{\\left< \\ , \\  \\right>}(H^{2,0},H^{0,2})$ is a space of skew-symmetric en\\-do\\-mor\\-phisms,  and since  $\\dim H^{2,0}$  $= 2$,
  we see that  $$\\dim Hom_{\\left< \\ ,\\ \\right>}(H^{2,0},H^{0,2}) = 1$$ The projection is a one-form $\\omega$ with values in the line bundle  $T_vD = Hom_{\\left< \\ , \\ \\right>}(H^{2,0},H^{0,2})$ whose kernel is $T_hD$.  Here $T_vD$ stands for the vertical bundle. To be a contact structure means that it is totally non-integrable.  This means the following: if $X,Y$ are horizontal vector fields, then, for all $p\\in D$,  $\\omega([X,Y])_p$ depends only on $X_p,Y_p$, hence defines a bundle map $\\Lambda^2 T_hD\\to T_vD$.  To be a contact structure then means that this is a non-degenerate pairing. In other words, the resulting map $T_h D\\to Hom(T_h D, T_v D)$ is an isomorphism.  This is a reformulation of the local coordinate condition $\\omega\\wedge (d\\omega)^{28}\\ne 0$ at every point.

  Under our identification $T_h D \\cong Hom(\\hodge^{2,0},\\hodge^{1,1})$, it is easy to check that  $\\omega([X,Y])= X^t Y - Y^t X$, where the transpose is with respect to $< \\ , \\ >$, see \\S 6 of \\cite{carlsontoledotrans} for details.  One easily checks  that this paring is non-degenerate, so that we indeed have a contact structure.


   Next, we  compute $dF$, where $F:S_{10}^0\\to \\Gamma\\backslash D$ is the period map of (\\ref{eq:universalperiodmaps}). The  group $G(1,1,2,5)$ of automorphisms of $P(1,1,2,5)$ acts on $S_{10}^0$ and  $F$ is  constant on orbits, so it should factor through  an appropriate quotient.  Since the group is not reductive, we avoid the technicalities of forming quotients, by working mostly on the  infinitesimal level.

   Given $f\\in S_{10}^0$, the tangent space at $f$ to its $G(1,1,2,5)$-orbit is $J_{10}(f)$.  When we have a quotient, $R_{10}(f)$ can be identified with the tangent space to the quotient at the orbit of $f$.   We  use this fact as a guiding principle, relying on the fact that $d_fF$ vanishes on $J_{10}(f)$ and hence factors through $R_{10}(f)$. Thus we avoid working with the quotient directly.


  To be more precise,  fix $f\\in S_{10}^0$ and a simply connected neighborhood $U$ of $f$.  Since $\\Gamma\\backslash D$ need not be a manifold (and will not be at points fixed by non-identity elements of $\\Gamma$), what we actually want to compute is $d_f\\widetilde{F}$, where $\\widetilde{F}:U\\to D$ is a local lift of $F$ as in (\\ref{eq:localuniversalperiodmaps}).




  Since $U$ is an open subset of the vector space $S_{10}$, there is a canonical identification
  \\begin{equation}
  \\label{eq:identifytangents}
  T_fU \\cong S_{10} \\ \\text{ by translation. }
  \\end{equation}
  Under this identification, $J_{10}(f)$ is the tangent space to the orbit of $f$. Consequently, $d_f\\widetilde{F}:S_{10}\\to T_hD$ vanishes on  $J_{10}(f)$, hence factors through $R_{10}(f)$.
  Keeping in mind the  exact sequence
   \\begin{equation}
  \\label{eq:exactsequence}
  0\\longrightarrow J_{10}(f) \\longrightarrow S_{10}\\buildrel p\\over\\longrightarrow R_{10}(f)\\longrightarrow 0,
  \\end{equation}
  we can state the main tool for computing differentials of period maps:

\\begin{proposition}

  \\label{prop:multiplication}
  Under the isomorphisms of Proposition \\ref{prop:jacobiancomputations}, the isomorphism (\\ref{eq:identifytangents}), and $p$ as in (\\ref{eq:exactsequence}),  we have a commutative diagram

  \\begin{eqnarray}
  \\begin{array}{ccccc}
  T_f U  &  &\\buildrel d_f\\widetilde{F} \\over \\longrightarrow & & T_hD \\cong Hom(H^{2,0},H^{1,1})\\\\
  {\\cong}\\Big\\downarrow & & & & \\Big\\downarrow {\\cong} \\\\
  S_{10} &\\buildrel p \\over \\longrightarrow & R_{10}(f)  & \\buildrel m \\over \\longrightarrow & Hom(R_1(f),R_{11}(f))
  \\end{array}
  \\end{eqnarray}

  where, for $\\phi\\in R_{10}$,  $m(\\phi):R_1\\to R_{11} $ is multiplication by $\\phi$: if $x\\in R_1$, then $m(\\phi)(x) = \\phi x$

\\end{proposition}

  \\begin{proof} This is the content of the residue calculus.  The isomorphisms between holomorphic objects and elements of the Jacobian ring preserve all natural products and pairings.
  \\end{proof}

  The above proposition will allow us to compute the rank of $d\\widetilde{F}$ at the point $f_0$ of (\\ref{eq:fermat}).  We remark that, up to this point, the residue calculus and the corresponding algebraic facts about the Jacobian ring have closely paralleled the projective case.  But the failure of Macauley's theorem in the weighted projective case forces us to look carefully at the remaining statements.   Most results in the literature require assumptions on the weights, and on the degree, that are not satisfied for degree $10$ and weights $(1,1,2,5)$.  See the introduction and \\S 1 of \\cite{donagitu} for a general discussion of the possible difficulties that can appear in the weighted case.

\\begin{proposition}
  \\label{prop:rank}

\\begin{enumerate}
  \\item The rank of $d\\widetilde{F}$ at $f_0$ is $28$, which is the maximum possible rank of a horizontal holomorphic map.

  \\item Let $W\\subset T_h D$ denote the image of $d\\widetilde{F}$.
  Under the identification $T_hD \\cong Hom(H^{2,0},H^{1,1})$, we have:

    \\item For each $v\\in H^{2,0}$, the subspace $Wv =_{def} \\{Xv\\  | \\  X\\in W\\}\\subset H^{1,1}$ has dimension $26$.

    \\item $\\{Xv \\ | \\  v\\in H^{2,0}, X\\in W\\} = H^{1,1}$

\\end{enumerate}
\\end{proposition}


\\strong{Proof}
  By Proposition \\ref{prop:multiplication} we need to compute the multiplication map $R_{10}\\to Hom(R_1,R_{11})$.  In the proof of Lemma \\ref{lem:dimensions} we found  a basis for $R_{11}$, and we can do a similar calculation with $R_{10}$:  a basis will be given by the monomials $x_1^a,x_2^b,x_3^c$ of total weight $10$ with $0\\le a,b \\le 8$ and $0\\le c \\le 3$.  These can again be conveniently grouped by the powers of $x_3$:


\\begin{enumerate}

    \\item $G_3' =\\left< x_1^ix_2^{4-i}x_3^3 | i = 0,\\dots 5 \\right>$ is five-dimensional
    \\item $G_2' =\\left< x_1^ix_2^{6-i}x_3^2 | i = 0,\\dots 5 \\right>$ is seven-dimensional
    \\item $G_1' =\\left< x_1^ix_2^{8-i}x_3 | i = 1,\\dots 8 \\right>$ is nine-dimensional
    \\item $G_0' =\\left< x_1^ix_2^{10-i} | i = 2,\\dots 8 \\right>$  is seven-dimensional

\\end{enumerate}


\\smallskip

  Therefore $\\dim R_{10} = 28$, as claimed.

  Next, we examine the map $m:R_{10}\\to Hom(R_1,R_{11})$, where $m(\\phi)$ is the homomorphism $m(\\phi)(x) = \\phi x$.  We claim that $m$  is injective.  Since $R_1=\\left< x_1,x_2 \\right>$, it suffices to show that if $\\phi\\in R_{10}$ and both $\\phi x_1 = \\phi x_2 = 0$, then $\\phi = 0$.  We have

  \\begin{equation}
  R_{10}=G_3'\\oplus G_2'\\oplus G_2'\\oplus G_0' \\ \\text{ and }\\  R_{11} = G_3\\oplus G_2 \\oplus G_1 \\oplus G_0,
  \\end{equation}

  it is easy to see that multiplication by $R_1$ maps $G_i'$ to $G_i$, that multiplication by $x_1$ is injective for $i=2,3$, and that the same holds for multiplication by $x_2$.  Moreover multiplication by either $x_1$ or $x_2$ is surjective for $i=0,1$ and the intersection of their kernels is zero.  Writing $\\phi = \\phi_3 + \\dots + \\phi_0$ and applying this information we see that $\\phi x_1 =\\phi x_2 = 0$ implies $\\phi = 0$.

  Combining these two facts, we see that $d_{f_0}\\widetilde{F}$ has rank $28$.  Since its image is an integral element of the holomorphic contact structure $T_hD$, its dimension can be at most half of $56$, the fiber dimension of $T_hD$.  Therefore $\\widetilde{F}$ has the highest possible rank of a horizontal holomorphic map, namely $28$.


  The second part is easily verified using the above bases of monomials. For $v=x_1$ or $x_2$, both assertions are clear, and they are easily checked for linear combinations $v = a x_1  + b x_2$.






  \\subsection{A closed horizontal subvariety of maximum dimension}

  Consider now the horizontal holomorphic map $F:S_{10}^0 \\to \\Gamma\\backslash D$.  Following Griffiths (see \\S 9 of \\cite{griffiths}) we can embed $S_{10}^0 \\subset S'$, where $S'$  is a smooth complex manifold containing $S_{10}^0$ as the complement of an analytic subset. One does this by  compactifying with normal crossing divisors.  One can then  extend over the branches of the compactifying divisor for which the monodromy is finite to obtain a proper horizontal holomorphic map $F:S'\\to\\Gamma\\backslash D$.  Then  $F(S')$ is a closed analytic subvariety of $\\Gamma\\backslash D$ containing $F(S_{10}^0)$ as the complement  of an analytic subvariety.

  At the point $f_0\\in S_{10}^0$, we found that a local lift $\\widetilde{F}:U\\to D$ has maximum rank $28$. Consequently, there is a neighborhood $U'$ of $f_0$, where $U'\\subset U$,  $\\widetilde{F}$ has rank $28$,   and $\\widetilde{F}|_{U'}$ is a submersion onto its image.  Therefore  $\\widetilde{F}(U')$ is a $28$-dimensional horizontal submanifold of $D$ containing $\\widetilde{F}(f_0)$.

  We now examine the local structure of $\\Gamma\\backslash D$.  Since $f_0$ has symmetries, $\\widetilde{F}(f_0)$ is fixed by some element $\\gamma\\in \\Gamma, \\gamma\\ne id$.  Let $\\Gamma_0$ denote the subgroup of $\\Gamma$ fixing  $\\widetilde{F}(f_0)$.  It is necessarily a finite group. If $N$ is a $\\Gamma_0$-invariant neighborhood of $\\widetilde{F}(f_0)$, then $\\Gamma_0\\backslash N$ is an orbifold  neighborhood of $F(f_0)$ in the orbifold $\\Gamma\\backslash D$, and $F(f_0)$ is a singular point of this orbifold.  Strictly speaking, we do not have a tangent space at $F(f_0)$.  But we can move away from $f_0$ in the above neighborhood $U'$ to find non-singular points:

\\begin{lemma}
\\label{lem:generic}
Let $W\\subset (T_h)_{\\widetilde{F}(f_0)} D$ denote the image of $d_{(f_0)}\\widetilde{F}$.  Then


\\begin{enumerate}
    \\item $W$ is not fixed by any $\\gamma\\in\\Gamma_0$, $\\gamma\\ne id$.

    \\item $W$ is not tangent to any horizontal geodesic embedding of  $SU(2,14)/S(U(2)\\times U(14))$ passing through $\\widetilde{F}(f_0)$.

\\end{enumerate}
\\end{lemma}

  \\strong{Proof}

  As usual, identify $T_hD$ with $Hom(H^{2,0},H^{1,1})$, and let $V = H^{2,0}$,   $V' = H^{1,1}$.  The group $\\Gamma_0$ acts on $T_h D$ through the action of the isotropy group $U(2)\\times SO(28)$ of $\\widetilde{F}(f_0)$.  Namely $(A,B)$, where $A\\in U(2)$ and $B\\in SO(28)$ acts on $X\\in Hom(V,V')$ by $X\\to BXA^{-1}$.


  Let us prove the stronger statement that $W$ is not fixed by any element of $U(2)\\times SO(28)$:  Suppose $X$ is fixed by $(A,B)\\ne id$, say $A\\ne id$.  Then $BX = XA$.   Let $\\lambda_1,\\lambda_2$ be the eigenvalues of $A$ (roots  of unity), and assume, first, that $\\lambda_1\\ne \\lambda_2$ and neither eigenvalue is real.  Let  $V_1,V_2$ be the corresponding eigenspaces, it is easy to see that, for $v_i\\in V_i$, $Xv_i$ is an eigenvector for $B$ with eigenvalue $\\lambda_i$.  From this we see that $V' = V_1'\\oplus V_2'\\oplus V_3'$, where $V_1',V_2'$ are the eigenspaces of $B$ for $\\lambda_1,\\lambda_2$ respectively,  and $V_3'$ is their orthogonal complement. If $X\\in W$, then $X(V_i)\\subset V_i'$ for $i=1,2$.  In other words, $W\\subset Hom(V_1,V_1')\\oplus Hom(V_2,V_2')$.  Observe that  $\\dim V_1', \\dim V_2'\\le 14$, since $B$ is real and its eigenvalues come in complex conjugate pairs.  Therefore, if $v_1\\in V_1$,
  $$
  \\{Xv_1 \\ | \\ X\\in W\\} \\subset V_1'.
  $$
  Since $\\dim V_1'\\le 14$, this contradicts Proposition  \\ref{prop:rank}.  The remaining possibilities for $\\lambda_1,\\lambda_2$ are  handled by similar  arguments.  This proves that $W$ is not fixed by any element of the isotropy group of $\\widetilde{F}(f_0)$. The first part of the Lemma is proved.

  For the second part, recall from \\S \\ref{subsec:construction} that the tangent space to a geodesic embedding of the symmetric space of $SU(2,14)$ through the point $V = H^{2,0}$ is determined by a complex structure $J$ on $V' = H^{1,1}$ and is the subspace  of $X\\in Hom(V,V')$ satisfying $JX = Xi$, in other words, the fixed point set of the element $(i,J)$ of $U(2)\\times SO(28)$, which we have  already excluded.



  An immediate consequence of this lemma is that $\\widetilde{F}(U')$ is not fixed by any $\\gamma\\in\\Gamma_0$, so there exist $f\\in U'$ with $F(f)$ a smooth point of $\\Gamma\\backslash D$.  The same must be true in a neighborhood $U''\\subset U'$ of $f$, so $F|_{U''}:U''\\to (\\Gamma\\backslash D )^0$  (the regular points of $\\Gamma\\backslash D$) and rank of $dF$ must be $28$ on $U''$.

In summary:

\\begin{theorem}
  Let $S'$, $F:S'\\to \\Gamma\\backslash D$ and $\\widetilde{F}:\\widetilde{S_{10}^0} \\to D$  be as above.  Then


\\begin{enumerate}
    \\item $F$ is a proper horizontal holomorphic map.
    \\item There is a proper analytic subvariety $Z\\subset S'$ so that, if $S'' = S'\\setminus Z$,  then  $F|_{S''}:S'' \\to (\\Gamma\\backslash D )^0$ and $dF$ has rank $28$ on $S''$.
    \\item $F(S')$ is a closed horizontal subvariety of $\\Gamma\\backslash D$ of maximum possible dimension $28$.

    \\item If $x\\in S''$, the tangent space to $F(S')$ at $F(x)$ is not the tangent space to any totally geodesic immersion of the symmetric space of $SU(2,14)$ in $\\Gamma\\backslash D$.

    \\item Alternatively, if $x\\in \\widetilde{S_{10}^0}$ lies in the dense open set where $d_x \\widetilde{F}$ has maximum rank $28$,   the image of $d_x \\widetilde{F}$ is not the  tangent space to a geodesic embedding of the symmetric space  $SU(2,14)$ in $D$.

\\end{enumerate}
\\end{theorem}

  \\section{Geodesic submanifolds and integral elements}
  \\label{sec:integralelements}

  We close with some remarks on integral elements of contact structures.  The period domains for which the horizontal bundle gives a contact structure are the twistor spaces of the quaternionic-K\\"ahler symmetric spaces, also called the Wolf spaces, see \\cite{wolf} for their classification.  We briefly discuss two examples from this point of view: our example $D$, associated to the symmetric space $SO(4,28)/S(O(4)\\times O(28))$, and another example we call $D'$ associated to quaternionic hyperbolic space.



  Whenever the horizontal sub-bundle $T_hD$ of a domain $D$  is a contact structure,  we know that each fiber of $T_h D$ has a symplectic structure, and the integral elements in that fiber are the Lagrangian subspaces of this symplectic structure.  Lagrangian subspaces of a $2g$-dimensional symplectic space are parametrized by $Sp(g)/U(g)$, the compact dual of the Siegel upper half plane of genus $g$.

  If $D = SO(4,28)/U(2)\\times SO(28)$ is the domain we have been studying, of dimension $57$, $T_hD$  of dimension $56$, the integral elements in a fiber of $T_hD$ are parametrized by $Sp(28)/U(28)$,  a manifold of complex dimension $(28 \\cdot 29)/2 = 406$.  On the other hand, the totally geodesic embeddings of $D_1$, the symmetric space for $SU(2,14)$ through a fixed point in $D$ are parametrized by the choice of complex structure $J$ on the space $H^+$ as in \\S \\ref{subsec:construction}.  These are in turn parametrized by the space $SO(28)/U(14)$ of dimension $28\\cdot 27 - 14^2 = 14\\cdot 13  = 182$.  Thus we see that the space of tangents to geodesic embeddings of $SU(2,14)$ is a rather small subset of the space of Lagrangian subspaces.  We therefore expect the generic horizontal map to miss these embeddings.  In a way, this is what made our example possible.

  \\subsection{The quaternionic hyperbolic space}
  \\label{subsec:quaternionic}

  We conclude with a related problem, which was the motivation for writing this paper.   Consider the period domain $D'$ associated to the quaternionic hyperbolic space, namely
     \\begin{eqnarray}
      \\label{eq:fibrationquat}
    \\begin{array}{ccc}
  Sp(1)/U(1) & \\longrightarrow & D' = Sp(1,n)/ U(1)\\times Sp(n) \\\\
  & & \\Big\\downarrow {\\pi}      \\\\
  & &  Sp(1,n) / Sp(1)\\cdot Sp(n)
  \\end{array}
  \\end{eqnarray}
  We can think of this domain as classifying Hodge structures on $\\R^{4n+4}\\cong \\bH^{n+1}$ with Hodge numbers $2,4n,2$ which are stable under right multiplication by quaternions.  Equivalently, we can think of points in this domain as pairs $L,J$ where $L\\subset \\bH^{n+1}$ is a positive right-quaternionic line and $J:L\\to L$ is a right quaternionic linear complex structure on $L$ orthogonal with respect to the polarizing form $\\left< \\ , \\ \\right>$.  Let $L^\\perp$ denote the orthogonal complement of $L$ in $\\bH^{n=1}$ and $L_\\C, L_\\C^\\perp$ their complexifications.  Then the horizontal tangent space to the domain $D'$ is

  \\begin{equation}
  T_n D' = _\\C\\Hom_\\bH (L^{1,0},L_\\C^\\perp)\\subset TD' = _\\C\\Hom_\\bH (L^{1,0},L_\\C^\\perp\\oplus L^{0,1})  \\nonumber
  \\end{equation}

  where $_\\C\\Hom_\\bH$ denotes left $\\C$-linear and right $\\bH$-linear homomorphisms.  See \\S 6 of \\cite{carlsontoledo} for a more detailed discussion.

  Once again, $D'$ has complex dimension $2n+1$ and $T_h D'$ has fiber dimension $2n$, so it is a holomorphic contact structure on $D'$.
  Each fiber  of $T_hD'$ has a symplectic structure, and the integral elements of the contact structure in a fixed fiber coincide with the Lagrangians of this symplectic structure, and are therefore parametrized by $Sp(n)/U(n)$.

  We also have horizontal totally geodesic embeddings of the symmetric space of $SU(1,n)$ in $D'$, namely the unit ball or complex hyperbolic space $SU(1,n)/U(n)$.  The group $Sp(n)$ acts transitively on the  embeddings passing through a point $(L,J)$, corresponding to orthogonal right $\\bH$-linear  complex structures on $L^\\perp$, hence parametrized by the same homogeneous space $Sp(n)/U(n)$ that parametrizes the Lagrangians.  Thus, for $D'$, every horizontal subvariety of maximum dimension $n$ is tangent, at each smooth point, to a horizontal totally geodesic  complex hyperbolic $n$-space.  (We used this fact in \\S 6 of \\cite{carlsontoledo} to give a structure theory for harmonic maps of K\\"ahler manifolds to manifolds covered by quaternionic hyperbolic space).

  \\begin{problem}
  Find examples of discrete groups $\\Gamma\\subset Sp(1,n)$ and closed horizontal subvarieties $V\\subset \\Gamma\\backslash D'$ that are not totally geodesic.
  \\end{problem}



\\begin{thebibliography}
\\bibitem[Ca86]{carlson} J. A. Carlson, \\emph{Bounds on the dimension of a variation of Hodge Structure}, Trans. AMS \\strong{294} (1986), 45 -- 64.

\\bibitem[CD87]{carlsondonagi} J. A. Carlson and R. Donagi, \\emph{Hypersurface variations are maximal}, I, Invent. Math. \\strong{89} (1987) 371--374.

\\bibitem[CT89a]{carlsontoledotrans} J. A. Carlson and D. Toledo, \\emph{Variations of Hodge structure, Legendre submanifolds, and accessibility}, Trans. AMS \\strong{311} (1989), 391--411

\\bibitem[CT89b]{carlsontoledo} J.A. Carlson and D. Toledo, \\emph{Harmonic mappings of K\\"ahler manifolds to locally symmetric spaces},  Pub. Maths. IHES \\strong{69} (1989), 173--201.

\\bibitem[Do82]{dolgachev} I. Dolgachev, \\emph{Weighted projective varieties}, in Lecture Notes in Mathematics \\strong{956}, 34--71, Springer, 1982.

\\bibitem[DT87]{donagitu}  R. Donagi and L. W. Tu, Generic Torelli for weighted hypersurfaces, Math. Annalen \\strong{276} (1987), 399 -- 413.

\\bibitem[G70]{griffiths} P. A, Griffiths, Periods of integrals on algebraic manifolds, III, Pub. Maths. IHES, \\strong{38} (1970), 125 --180.

\\bibitem[S77]{steenbrink}  J. Steenbrink, Intersection form for quasi-homogeneous singularities, Comp. Math. \\strong{34} (1977), 211--223.

\\bibitem[W65]{wolf} J. A Wolf, Complex homogeneous contact manifolds and quaternionic symmetric spaces, Jour. Math. Mechanics \\strong{14} (1965), 1033--1048.

\\end{thebibliography}


"""



-- \\bibitem[Ca86]{carlson} J. A. Carlson, \\emph{Bounds on the dimension of a variation of Hodge Structure}, Trans. AMS \\strong{294} (1986), 45 -- 64.
--
-- \\bibitem[CD87]{carlsondonagi} J. A. Carlson and R. Donagi, \\emph{Hypersurface variations are maximal}, I, Invent. Math. \\strong{89} (1987) 371--374.
--
-- \\bibitem[CT89a]{carlsontoledotrans} J. A. Carlson and D. Toledo, \\emph{Variations of Hodge structure, Legendre submanifolds, and accessibility}, Trans. AMS \\strong{311} (1989), 391--411
--
-- \\bibitem[CT89b]{carlsontoledo} J.A. Carlson and D. Toledo, \\emph{Harmonic mappings of K\\"ahler manifolds to locally symmetric spaces},  Pub. Maths. IHES \\strong{69} (1989), 173--201.
--
-- \\bibitem[Do82]{dolgachev} I. Dolgachev, \\emph{Weighted projective varieties}, in Lecture Notes in Mathematics \\strong{956}, 34--71, Springer, 1982.
--
-- \\bibitem[DT87]{donagitu}  R. Donagi and L. W. Tu, Generic Torelli for weighted hypersurfaces, Math. Annalen \\strong{276} (1987), 399 -- 413.
--
-- \\bibitem[G70]{griffiths} P. A, Griffiths, Periods of integrals on algebraic manifolds, III, Pub. Maths. IHES, \\strong{38} (1970), 125 --180.
--
-- \\bibitem[S77]{steenbrink}  J. Steenbrink, Intersection form for quasi-homogeneous singularities, Comp. Math. \\strong{34} (1977), 211--223.
--
-- \\bibitem[W65]{wolf} J. A Wolf, Complex homogeneous contact manifolds and quaternionic symmetric spaces, Jour. Math. Mechanics \\strong{14} (1965), 1033--1048.


grammar =
    """

\\title{MiniLaTeX Grammar (Draft)}

\\author{James A. Carlson}

\\email{jxxcarlson at gmail}

\\date{January 12, 2018}

\\maketitle

\\tableofcontents


  $$
  \\newcommand{\\dollar}{ \\text{$ \\$ $} }
  \\newcommand{\\begg}[1]{\\text{\\begin{$#1$}}}
  \\newcommand{\\endd}[1]{\\text{\\end{$#1$}}}
  $$

  \\section{Introduction}

  In this article, we describe a formal grammar which defines the MiniLaTeX language.  MiniLaTex is a subset of LaTeX, and  text written in it can be translated into HTML by means of a suitable parser-renderer.  Because of the balanced begin-end pairs characteristic of LaTeX environments and the fact that the number of distinct such pairs is arbitrary, the grammar is not context-free.  The context sensitivity is, however, limited.  Indeed, it occurs in only in the productions for environments and tables, so that the grammatical description is "almost EBNF."

  The MiniLaTex parser is written in Elm.  Elm is the functional language for creating web apps developed by Evan Czaplicki, first announced in his Harvard senior thesis (2012).  The  choice of language was governed by two considerations. First, Elm provides excellent tools for creating fast, reliable web apps with a codebase that is maintainable over the long run.  This was an important consideration, since the point of MiniLaTeX is to be able to create, edit, and distribute technical documents in HTML.  The second consideration is that Elm, with its ML-flavored type system and an expressive parser combinator library, is well-suited to the task of realizing a grammar.  The resulting parser is quite compact --- just 336 lines of code as of this writing.

  A second implementation of the parser in Haskell is planned in order to have additional validation of MiniLaTeX and to make it more widely available.  The Haskell parser will be released with a command-line tool for translating MiniLaTeX into HTML.

  The code for the MiniLaTeX parser-renderer is open source, available on  \\href{https://github.com/jxxcarlson/minilatex}{GitHub}
  and also as an Elm package at \\href{http://package.elm-lang.org/packages/jxxcarlson/minilatex/latest}{package.elm-lang.org} --- search for \\code{jxxcarlson/minilatex}.
  To experiment with MiniLaTeX, try the \\href{https://jxxcarlson.github.io/app/minilatex/src/index.html}{Demo App}.  To use MiniLaTeX to create documents, try \\href{http://www.knode.io}{www.knode.io}

  I am indebted to Ilias van Peer for thoughtful suggestions and specific technical help through the entire course of this project.  I would also like to thank Evan Czaplicki, who brought Elm's \\href{https://github.com/elm-tools/parser}{elm-tools/parser} package to my attention; its role is fundamental.

  This document is written in MiniLaTeX and is available on the web at
  \\href{http://www.knode.io/#@public/628}{www.knode.io/#@public/628}.



  \\section{Abstract Syntax Tree}

  The MiniLatex parser accepts text as input and produces an abstract syntax tree (AST) as output.  An AST is a $LatexExpression$, as defined by the following type.

  \\begin{verbatim}
  type LatexExpression
      = LXString String
      | Comment String
      | InlineMath String
      | DisplayMath String
      | Item Int LatexExpression
      | Macro String (List LatexExpression)
      | Environment String LatexExpression
      | LatexList (List LatexExpression)
  \\end{verbatim}

  The translation from source text to abstract syntax tree is accomplished by a function in the \\code{MiniLatex.Parser} module:

  \\begin{equation}
  parse: {\\tt String} \\rightarrow {\\tt LatexExpression}.
  \\end{equation}

  The abstract syntax tree of MiniLaTeX text carries the information
  needed to render it either as LaTeX or as HTML. Thus one can construct functions


  \\begin{align}
  renderToLatex &: LatexExpression \\rightarrow String \\\\
  renderToHtml &: LatexExpression \\rightarrow String
  \\end{align}

  One might think of the function $renderToLatex$ as an inverse of $parse$, since it reverses the role of domain and codomain.  Nonetheless, this is not the case, since one can make changes to the source text which do not affect the AST.  It is possible, however, to state a related property.  Let
   $f = renderToLatex\\circ parse$.  This is a function \\code{String -> String}; although one cannot assert that $f = id$, one has the
  idempotency relation $f\\circ f = f$.



  \\section{Terminals and Non-Terminals}

  Let us now describe the grammar, beginning with terminal and nonterminal symbols.  In the next section we list and discuss the productions of this grammar.

  \\subheading{Terminals}

\\begin{enumerate}

  \\item $spaces \\Rightarrow sp^*$, where $sp$ is the space character.

  \\item $ws \\Rightarrow \\{ sp, nl \\}^*$, where $nl$ is the newline character.

  \\item $reservedWord \\Rightarrow \\{ \\backslash begin, \\backslash end, \\backslash item \\}$

  \\item $word \\Rightarrow (Char - \\{sp, nl, backslash, dollarSign \\})^+$ -- Nonempty strings without whitespace characters, backslashes or dollar signs

  \\item $specialWord \\Rightarrow (Char - \\{sp, nl, backslash, dollarSign, \\}, \\& \\})^+$

  \\item $macroName \\Rightarrow  (Char - \\{sp, nl, , leftBrace, backslash\\})^+ - reservedWord$

\\end{enumerate}

  Associated with these terminals are productions $Word \\Rightarrow word$, $Identifier \\Rightarrow identifier$, etc.  We shall not list all of these, but rather just the terminal and a description of it.



  \\subheading{Non-Terminals}


  \\begin{enumerate}
  \\item $Arg$ -- arguments for macros
  \\item $BeginWord$ -- produce $\\begg{identifier}$ phrase for LaTeX environments.
  \\item $Comment$ -- LaTeX comments -- \\% foo, bar
  \\item $IMath$ -- inline mathematical text, as in $\\dollar$ ... $\\dollar$
  \\item $DMath$ -- display mathematical text, as in $\\dollar\\dollar$ ... $\\dollar\\dollar$ or $\\backslash[\\ ... \\backslash]$.
  \\item $Env$ -- LaTeX environments $\\begg{foo}\\ $ ... $\\endd{foo}$.
  \\item $EnvName$ -- produce an environment name such as \\italic{foo}, or \\italic{theorem}.
  \\item $Identifier$ -- a lowercase alphanumeric string beginning with a letter.
  \\item $Item$ -- item in an enumeration or itemization environemnt
  \\item $LatexExpression$ -- a union type
  \\item $LatexList$ -- a list of LatexExpressions
  \\item $Macro$ -- a LaTeX macro of zero or more arguments.
  \\item $MacroName$ -- an identifier
  \\item $Words$ -- a string obtained by joining a list of $Word$ with spaces.
  \\end{enumerate}


  \\section{Productions}



  The MiniLaTeX grammar is defined by its productions.  This set is fairly small, just 24 if one discounts productions which could be viewed as performing lexical analysis -- the recognition of identifiers, for instance.  Of the 24 productions, 11 are for general nonterminals, 7 are for environments of various kinds, and 5 are for the tabular environment.  With two exceptions we present them in EBNF form.  The topmost productions are for $LatexList$ and $LatexExpression$:

  \\begin{align}
  \\label{Production:LatexExpression}
  LatexList &\\Rightarrow LatexExpression^+ \\\\
  LatexExpression &\\Rightarrow Words\\ |\\ Comment\\ |\\ IMath\\ |\\ DMath\\  \\\\
  & \\phantom{\\Rightarrow}\\ |\\ Macro\\ |\\ Env
  \\end{align}

  The productions for the first four non-terminals on the right-hand side of \\eqref{Production:LatexExpression} are non-recursive, straightforward, and all result in a terminal.
  The terminal is of the form $Constructor\\ x$, where the first term is a constructor for $LatexExpression$ and $x$ is a string.  When $A$ is a non-terminal, ${\\tt A}$ is the
  corresponding constructor.

\\begin{enumerate}

  \\item $ Words  \\Rightarrow {\\tt LXString}\\ (join\\ Word^+) $ where a $Word$ is any sequence of characters which is not a whitespace character, $\\backslash$, or $\\dollar$, and where $join$ is the function which joins the elements of a list of strings by single spaces to produce a string.

  \\item $ Comment \\Rightarrow {\\tt Comment}\\ (Char - \\{ \\text{\\n}\\})^* $

  \\item $ IMath  \\Rightarrow {\\tt IMath}\\ Line'$ where $Line'$ is $Line$ with no occurernce of $\\dollar$

  \\item $ DMath  \\Rightarrow {\\tt DMath}\\ Line'\\ |\\ {\\tt DMath}\\ Line'' $ | where $Line''$ is $Line$ with no occurrence of of a right bracket.

\\end{enumerate}

  Let us now treat the two recursive productions. They generate LaTeX macros and environments.


  \\subsection{Macros}

  \\begin{align}
  Macro &\\Rightarrow {\\tt Macro}\\ Macroname\\ Arg^* \\\\
  Arg &\\Rightarrow Words\\ |\\ IMath\\ |\\ Macro
  \\end{align}


  \\subsection{Environments}


  Because of the use of constructions of the form

  \\begin{verbatim}
  \\begin{envName}
  ...
  \\end{envName}
  \\end{verbatim}

  the production of environments requires  the use of a context-sensitive grammar.
  Here $envName$ may take on arbitrarily many values, and, in particular, values not known at the time the parser is written.  Note that the production \\eqref{production:envname} below has a nonterminal followed by a terminal on the right-hand side, while \\eqref{production:env} has a nonterminal followed by a terminal on the left-hand side.  The presence of a terminal on the left-hand side tells us that the grammar is context-sensitive. In $Env\\ identifier$, the terminal $identifier$ provides the context.

  \\begin{equation}
  \\label{production:envname}
  EnvName \\Rightarrow Env\\ identifier
  \\end{equation}

  \\begin{align}
  \\label{production:env}
  Env\\ {\\rm itemize} & \\Rightarrow {\\tt Environment}\\ {\\rm itemize}\\ Item^+ \\\\
  Env\\ {\\rm enumerate} & \\Rightarrow {\\tt Environment}\\ {\\rm enumerate}\\ Item^+\\\\
  Env\\ {\\rm tabular} & \\Rightarrow {\\tt Environment}\\ {\\rm tabular} \\ Table \\\\
  Env\\ passThroughIdentifier & \\Rightarrow {\\tt Environment}\\ passThroughIdentifier\\ Text \\\\
  Env\\ genericIdentifier & \\Rightarrow {\\tt Environment}\\ genericIdentifier\\ LatexList \\\\
  \\end{align}

  The set of all $envNames$ is decomposed as follows:

  \\begin{align}
  specialIdentifier &= \\{ \\text{itemize, enumerate, tabular} \\} \\\\
  passThroughIdentifier &= \\{ \\text{equation, align, eqnarray, verbatim, verse} \\} \\\\
  genericIdentifier &= identifier - specialIdentifier - passThroughIdentifier
  \\end{align}


  \\subsection{Tabular Environment}

  The tabular environment also requires a context-sensitive grammar.

  \\begin{align}
  Table &\\Rightarrow TableHead\\ (TableRows\\ ncols)^+ \\\\
  TableRows\\ ncols &\\Rightarrow TableCells^{ncols}
  \\end{align}



"""
