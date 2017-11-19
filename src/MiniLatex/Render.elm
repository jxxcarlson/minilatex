module MiniLatex.Render
    exposing
        ( transformText
        , render
        , renderLatexList
        , renderString
        )

import MiniLatex.Parser exposing (LatexExpression(..), latexList, defaultLatexList)
import MiniLatex.KeyValueUtilities as KeyValueUtilities
import MiniLatex.LatexState
    exposing
        ( LatexState
        , emptyLatexState
        , getCrossReference
        , getCounter
        )
import MiniLatex.Configuration as Configuration
import Dict
import List.Extra
import Parser
import String.Extra


transformText : LatexState -> String -> String
transformText latexState text =
    renderString latexList latexState text



-- |> \str -> "\n<p>" ++ str ++ "</p>\n"
{- FUNCTIONS FOR TESTING THINGS -}


getElement : Int -> List LatexExpression -> LatexExpression
getElement k list =
    List.Extra.getAt k list |> Maybe.withDefault (LXString "xxx")


parseString parser str =
    Parser.run parser str


renderString parser latexState str =
    let
        parserOutput =
            Parser.run parser str

        renderOutput =
            case parserOutput of
                Ok latexExpression ->
                    render latexState latexExpression

                Err _ ->
                    "PARSE ERROR"
    in
        renderOutput



{- TYPES AND DEFAULT VALJUES -}


extractList : LatexExpression -> List LatexExpression
extractList latexExpression =
    case latexExpression of
        LatexList a ->
            a

        _ ->
            []


{-| THE MAIN RENDING FUNCTION
-}
render : LatexState -> LatexExpression -> String
render latexState latexExpression =
    case latexExpression of
        Comment str ->
            renderComment str

        Macro name args ->
            renderMacro latexState name args

        Item level latexExpression ->
            renderItem latexState level latexExpression

        InlineMath str ->
            " $" ++ str ++ "$ "

        DisplayMath str ->
            "$$" ++ str ++ "$$"

        Environment name args ->
            renderEnvironment latexState name args

        LatexList args ->
            renderLatexList latexState args

        LXString str ->
            xRenderString str


xRenderString str =
    str


spaceify str =
    let
        lastChar =
            String.right 1 str

        firstChar =
            String.left 1 str
    in
        if List.member str [ ".", ",", "?", "!", ";", ":" ] then
            str
        else if List.member firstChar [ ".", ",", "?", "!", ";", ":" ] then
            str
        else
            " " ++ str



{- RENDER ELEMENTS -}


renderLatexList : LatexState -> List LatexExpression -> String
renderLatexList latexState args =
    args |> List.map (render latexState) |> List.map spaceify |> String.join ("")


renderArgList : LatexState -> List LatexExpression -> String
renderArgList latexState args =
    args |> List.map (render latexState) |> List.map (\x -> "{" ++ x ++ "}") |> String.join ("")


itemClass : Int -> String
itemClass level =
    "item" ++ (toString level)


renderItem : LatexState -> Int -> LatexExpression -> String
renderItem latexState level latexExpression =
    "<li class=\"" ++ (itemClass level) ++ "\">" ++ (render latexState latexExpression) ++ "</li>\n"


renderComment : String -> String
renderComment str =
    ""



{- ENVIROMENTS -}


renderEnvironmentDict : Dict.Dict String (LatexState -> LatexExpression -> String)
renderEnvironmentDict =
    Dict.fromList
        [ ( "align", \x y -> renderAlignEnvironment x y )
        , ( "center", \x y -> renderCenterEnvironment x y )
        , ( "enumerate", \x y -> renderEnumerate x y )
        , ( "eqnarray", \x y -> renderEqnArray x y )
        , ( "equation", \x y -> renderEquationEnvironment x y )
        , ( "itemize", \x y -> renderItemize x y )
        , ( "macros", \x y -> renderMacros x y )
        , ( "tabular", \x y -> renderTabular x y )
        , ( "verbatim", \x y -> renderVerbatim x y )
        ]


environmentRenderer : String -> (LatexState -> LatexExpression -> String)
environmentRenderer name =
    case Dict.get name renderEnvironmentDict of
        Just f ->
            f

        Nothing ->
            renderDefaultEnvironment name


renderEnvironment : LatexState -> String -> LatexExpression -> String
renderEnvironment latexState name body =
    (environmentRenderer name) latexState body


renderDefaultEnvironment : String -> LatexState -> LatexExpression -> String
renderDefaultEnvironment name latexState body =
    if List.member name [ "theorem", "proposition", "corollary", "lemma", "definition" ] then
        renderTheoremLikeEnvironment latexState name body
    else
        renderDefaultEnvironment2 latexState name body


renderTheoremLikeEnvironment : LatexState -> String -> LatexExpression -> String
renderTheoremLikeEnvironment latexState name body =
    let
        r =
            render latexState body

        eqno =
            getCounter "eqno" latexState

        s1 =
            getCounter "s1" latexState

        tno =
            getCounter "tno" latexState

        tnoString =
            if s1 > 0 then
                " " ++ (toString s1) ++ "." ++ (toString tno)
            else
                " " ++ (toString tno)
    in
        "\n<div class=\"environment\">\n<strong>" ++ (String.Extra.toSentenceCase name) ++ tnoString ++ "</strong>\n<div class=\"italic\">\n" ++ r ++ "\n</div>\n</div>\n"


renderDefaultEnvironment2 : LatexState -> String -> LatexExpression -> String
renderDefaultEnvironment2 latexState name body =
    let
        r =
            render latexState body
    in
        "\n<div class=\"environment\">\n<strong>" ++ (String.Extra.toSentenceCase name) ++ "</strong>\n<div class=\"italic\">\n" ++ r ++ "\n</div>\n</div>\n"


renderCenterEnvironment latexState body =
    let
        r =
            render latexState body
    in
        "\n<div class=\"center\" >\n" ++ r ++ "\n</div>\n"


renderEquationEnvironment latexState body =
    let
        eqno =
            getCounter "eqno" latexState

        s1 =
            getCounter "s1" latexState

        addendum =
            if eqno > 0 then
                if s1 > 0 then
                    "\\tag{" ++ (toString s1) ++ "." ++ (toString eqno) ++ "}"
                else
                    "\\tag{" ++ (toString eqno) ++ "}"
            else
                ""

        r =
            render latexState body
    in
        "\n$$\n\\begin{equation}" ++ addendum ++ r ++ "\\end{equation}\n$$\n"


renderAlignEnvironment latexState body =
    let
        r =
            (render latexState body) |> String.Extra.replace "\\ \\" "\\\\"

        eqno =
            getCounter "eqno" latexState

        s1 =
            getCounter "s1" latexState

        addendum =
            if eqno > 0 then
                if s1 > 0 then
                    "\\tag{" ++ (toString s1) ++ "." ++ (toString eqno) ++ "}"
                else
                    "\\tag{" ++ (toString eqno) ++ "}"
            else
                ""
    in
        "\n$$\n\\begin{align}\n" ++ addendum ++ r ++ "\n\\end{align}\n$$\n"


renderEqnArray latexState body =
    "\n$$\n" ++ (render latexState body) ++ "\n$$\n"


renderEnumerate latexState body =
    "\n<ol>\n" ++ (render latexState body) ++ "\n</ol>\n"


renderItemize latexState body =
    "\n<ul>\n" ++ (render latexState body) ++ "\n</ul>\n"


renderMacros latexState body =
    "\n$$\n" ++ (render latexState body) ++ "\n$$\n"


renderTabular latexState body =
    renderTableBody body


renderCell cell =
    case cell of
        LXString s ->
            "<td>" ++ s ++ "</td>"

        InlineMath s ->
            "<td>$" ++ s ++ "$</td>"

        _ ->
            "<td>-</td>"


renderRow row =
    case row of
        LatexList row_ ->
            row_
                |> List.foldl (\cell acc -> acc ++ " " ++ (renderCell cell)) ""
                |> \row -> "<tr> " ++ row ++ " </tr>\n"

        _ ->
            "<tr>-</tr>"


renderTableBody body =
    case body of
        LatexList body_ ->
            body_
                |> List.foldl (\row acc -> acc ++ " " ++ (renderRow row)) ""
                |> \body -> "<table>\n" ++ body ++ "</table>\n"

        _ ->
            "<table>-</table>"


renderVerbatim latexState body =
    "\n<pre class=\"verbatim\">" ++ (render latexState body) ++ "</pre>\n"



{- MACROS: DISPATCHERS AND HELPERS -}


renderMacroDict : Dict.Dict String (LatexState -> List LatexExpression -> String)
renderMacroDict =
    Dict.fromList
        [ ( "bozo", \x y -> renderBozo x y )
        , ( "cite", \x y -> renderCite x y )
        , ( "code", \x y -> renderCode x y )
        , ( "ellie", \x y -> renderEllie x y )
        , ( "emph", \x y -> renderItalic x y )
        , ( "eqref", \x y -> renderEqRef x y )
        , ( "href", \x y -> renderHRef x y )
        , ( "iframe", \x y -> renderIFrame x y )
        , ( "image", \x y -> renderImage x y )
        , ( "index", \x y -> "" )
        , ( "italic", \x y -> renderItalic x y )
        , ( "label", \x y -> "" )
        , ( "maketitle", \x y -> "" )
        , ( "mdash", \x y -> "&mdash;" )
        , ( "ndash", \x y -> "&ndash;" )
        , ( "newcommand", \x y -> renderNewCommand x y )
        , ( "ref", \x y -> renderRef x y )
        , ( "section", \x y -> renderSection x y )
        , ( "section*", \x y -> renderSectionStar x y )
        , ( "setcounter", \x y -> "" )
        , ( "strong", \x y -> renderStrong x y )
        , ( "subheading", \x y -> renderSubheading x y )
        , ( "subsection", \x y -> renderSubsection x y )
        , ( "subsection*", \x y -> renderSubsectionStar x y )
        , ( "subsubsection", \x y -> renderSubSubsection x y )
        , ( "subsubsection*", \x y -> renderSubSubsectionStar x y )
        , ( "title", \x y -> renderTitle x y )
        , ( "term", \x y -> renderTerm x y )
        , ( "xlink", \x y -> renderXLink x y )
        , ( "xlinkPublic", \x y -> renderXLinkPublic x y )
        ]


macroRenderer : String -> (LatexState -> List LatexExpression -> String)
macroRenderer name =
    case Dict.get name renderMacroDict of
        Just f ->
            f

        Nothing ->
            reproduceMacro name


reproduceMacro : String -> LatexState -> List LatexExpression -> String
reproduceMacro name latexState args =
    "\\" ++ name ++ (renderArgList emptyLatexState args)


renderMacro : LatexState -> String -> List LatexExpression -> String
renderMacro latexState name args =
    (macroRenderer name) latexState args


renderArg : Int -> LatexState -> List LatexExpression -> String
renderArg k latexState args =
    render latexState (getElement k args) |> String.trim



{- INDIVIDUAL MACRO RENDERERS -}


renderBozo : LatexState -> List LatexExpression -> String
renderBozo latexState args =
    "bozo{" ++ (renderArg 0 latexState args) ++ "}{" ++ (renderArg 1 latexState args) ++ "}"


{-| Needs work
-}
renderCite : LatexState -> List LatexExpression -> String
renderCite latexState args =
    " <strong>" ++ (renderArg 0 latexState args) ++ "</strong>"


renderCode : LatexState -> List LatexExpression -> String
renderCode latexState args =
    " <span class=\"code\">" ++ (renderArg 0 latexState args) ++ "</span>"


renderEllie : LatexState -> List LatexExpression -> String
renderEllie latexState args =
    let
        src =
            "src =\"https://ellie-app.com/embed/" ++ (renderArg 0 latexState args) ++ "\""

        url =
            "https://ellie-app.com/" ++ (renderArg 0 latexState args)

        title_ =
            renderArg 1 latexState args

        foo =
            27.99

        title =
            if title_ == "xxx" then
                "Link to Ellie"
            else
                title_

        style =
            " style = \"width:100%; height:400px; border:0; border-radius: 3px; overflow:hidden;\""

        sandbox =
            " sandbox=\"allow-modals allow-forms allow-popups allow-scripts allow-same-origin\""
    in
        "<iframe " ++ src ++ style ++ sandbox ++ " ></iframe>\n<center style=\"margin-top: -10px;\"><a href=\"" ++ url ++ "\" target=_blank>" ++ title ++ "</a></center>"


renderEqRef : LatexState -> List LatexExpression -> String
renderEqRef latexState args =
    let
        key =
            renderArg 0 emptyLatexState args

        ref =
            getCrossReference key latexState
    in
        "$(" ++ ref ++ ")$"


renderHRef : LatexState -> List LatexExpression -> String
renderHRef latexState args =
    let
        url =
            renderArg 0 emptyLatexState args

        label =
            renderArg 1 emptyLatexState args
    in
        " <a href=\"" ++ url ++ "\" target=_blank>" ++ label ++ "</a>"


renderIFrame : LatexState -> List LatexExpression -> String
renderIFrame latexState args =
    let
        url =
            renderArg 0 emptyLatexState args

        src =
            "src =\"" ++ url ++ "\""

        title_ =
            renderArg 1 emptyLatexState args

        title =
            if title_ == "xxx" then
                "Link"
            else
                title_

        height_ =
            renderArg 2 emptyLatexState args

        height =
            if (title_ == "xxx" || height_ == "xxx") then
                "400px"
            else
                height_

        sandbox =
            ""

        style =
            " style = \"width:100%; height:" ++ height ++ "; border:1; border-radius: 3px; overflow:scroll;\""
    in
        "<iframe scrolling=\"yes\" " ++ src ++ sandbox ++ style ++ " ></iframe>\n<center style=\"margin-top: 0px;\"><a href=\"" ++ url ++ "\" target=_blank>" ++ title ++ "</a></center>"


renderImage : LatexState -> List LatexExpression -> String
renderImage latexState args =
    let
        url =
            renderArg 0 latexState args

        label =
            renderArg 1 latexState args

        attributeString =
            renderArg 2 latexState args

        imageAttrs =
            parseImageAttributes attributeString
    in
        if imageAttrs.float == "left" then
            handleFloatedImageLeft url label imageAttrs
        else if imageAttrs.float == "right" then
            handleFloatedImageRight url label imageAttrs
        else if imageAttrs.align == "center" then
            handleCenterImage url label imageAttrs
        else
            "<image src=\"" ++ url ++ "\" " ++ (imageAttributes imageAttrs attributeString) ++ " >"


renderItalic : LatexState -> List LatexExpression -> String
renderItalic latexState args =
    " <span class=italic>" ++ (renderArg 0 latexState args) ++ "</span>"


renderNewCommand : LatexState -> List LatexExpression -> String
renderNewCommand latexState args =
    let
        command =
            renderArg 0 latexState args

        definition =
            renderArg 1 latexState args
    in
        "\\newcommand{" ++ command ++ "}{" ++ definition ++ "}"


renderRef : LatexState -> List LatexExpression -> String
renderRef latexState args =
    let
        key =
            renderArg 0 latexState args
    in
        getCrossReference key latexState


renderSection : LatexState -> List LatexExpression -> String
renderSection latexState args =
    let
        arg =
            renderArg 0 latexState args

        s1 =
            getCounter "s1" latexState

        addendum =
            if s1 > 0 then
                (toString s1) ++ " "
            else
                ""
    in
        "<h2>" ++ addendum ++ arg ++ "</h2>"


renderSectionStar : LatexState -> List LatexExpression -> String
renderSectionStar latexState args =
    "<h2>" ++ (renderArg 0 latexState args) ++ "</h2>"


renderStrong : LatexState -> List LatexExpression -> String
renderStrong latexState args =
    " <span class=\"strong\">" ++ (renderArg 0 latexState args) ++ "</span> "


renderSubheading : LatexState -> List LatexExpression -> String
renderSubheading latexState args =
    "<div class=\"subheading\">" ++ (renderArg 0 latexState args) ++ "</div>"


renderSubsection : LatexState -> List LatexExpression -> String
renderSubsection latexState args =
    let
        arg =
            renderArg 0 latexState args

        s1 =
            getCounter "s1" latexState

        s2 =
            getCounter "s2" latexState

        addendum =
            if s1 > 0 then
                (toString s1) ++ "." ++ (toString s2) ++ " "
            else
                ""
    in
        "<h3>" ++ addendum ++ arg ++ "</h3>"


renderSubsectionStar : LatexState -> List LatexExpression -> String
renderSubsectionStar latexState args =
    let
        arg =
            renderArg 0 latexState args
    in
        "<h3>" ++ arg ++ "</h3>"


renderSubSubsection : LatexState -> List LatexExpression -> String
renderSubSubsection latexState args =
    let
        arg =
            renderArg 0 latexState args

        s1 =
            getCounter "s1" latexState

        s2 =
            getCounter "s2" latexState

        s3 =
            getCounter "s3" latexState

        addendum =
            if s1 > 0 then
                (toString s1) ++ "." ++ (toString s2) ++ "." ++ (toString s3) ++ " "
            else
                ""
    in
        "<h4>" ++ addendum ++ arg ++ "</h4>"


renderSubSubsectionStar : LatexState -> List LatexExpression -> String
renderSubSubsectionStar latexState args =
    let
        arg =
            renderArg 0 latexState args
    in
        "<h4>" ++ arg ++ "</h4>"


renderTitle : LatexState -> List LatexExpression -> String
renderTitle latexState args =
    let
        arg =
            renderArg 0 latexState args
    in
        "<h1>" ++ arg ++ "</h1>"


renderTerm : LatexState -> List LatexExpression -> String
renderTerm latexState args =
    let
        arg =
            renderArg 0 latexState args
    in
        " <span class=italic>" ++ arg ++ "</span>"


renderXLink : LatexState -> List LatexExpression -> String
renderXLink latexState args =
    let
        id =
            renderArg 0 latexState args

        label =
            renderArg 1 latexState args
    in
        " <a href=\"" ++ Configuration.client ++ "##document/" ++ id ++ "\">" ++ label ++ "</a>"


renderXLinkPublic : LatexState -> List LatexExpression -> String
renderXLinkPublic latexState args =
    let
        id =
            renderArg 0 latexState args

        label =
            renderArg 1 latexState args
    in
        " <a href=\"" ++ Configuration.client ++ "##public/" ++ id ++ "\">" ++ label ++ "</a>"



{- IMAGE HELPERS -}


handleCenterImage url label imageAttributes =
    let
        width =
            imageAttributes.width

        imageCenterLeftPart width =
            "<div class=\"center\" style=\"width: " ++ (toString (width + 20)) ++ "px; margin-left:auto, margin-right:auto; text-align: center;\">"
    in
        (imageCenterLeftPart width) ++ "<img src=\"" ++ url ++ "\" width=" ++ (toString width) ++ " ><br>" ++ label ++ "</div>"


handleFloatedImageRight url label imageAttributes =
    let
        width =
            imageAttributes.width

        imageRightDivLeftPart width =
            "<div style=\"float: right; width: " ++ (toString (width + 20)) ++ "px; margin: 0 0 7.5px 10px; text-align: center;\">"
    in
        (imageRightDivLeftPart width) ++ "<img src=\"" ++ url ++ "\" width=" ++ (toString width) ++ "><br>" ++ label ++ "</div>"


handleFloatedImageLeft url label imageAttributes =
    let
        width =
            imageAttributes.width

        imageLeftDivLeftPart width =
            "<div style=\"float: left; width: " ++ (toString (width + 20)) ++ "px; margin: 0 10px 7.5px 0; text-align: center;\">"
    in
        (imageLeftDivLeftPart width) ++ "<img src=\"" ++ url ++ "\" width=" ++ (toString width) ++ "><br>" ++ label ++ "</div>"


type alias ImageAttributes =
    { width : Int, float : String, align : String }


parseImageAttributes : String -> ImageAttributes
parseImageAttributes attributeString =
    let
        kvList =
            KeyValueUtilities.getKeyValueList attributeString

        widthValue =
            KeyValueUtilities.getValue "width" kvList |> String.toInt |> Result.withDefault 200

        floatValue =
            KeyValueUtilities.getValue "float" kvList

        alignValue =
            KeyValueUtilities.getValue "align" kvList
    in
        ImageAttributes widthValue floatValue alignValue


imageAttributes : ImageAttributes -> String -> String
imageAttributes imageAttrs attributeString =
    let
        widthValue =
            imageAttrs.width |> toString

        widthElement =
            if widthValue /= "" then
                "width=" ++ widthValue
            else
                ""
    in
        widthElement
