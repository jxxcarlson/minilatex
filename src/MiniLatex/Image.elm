module MiniLatex.Image exposing (..)

import MiniLatex.Html as Html
import MiniLatex.KeyValueUtilities as KeyValueUtilities


{- IMAGE HELPERS -}


imageCenterStyle imageAttributes =
    "class=\"center\" style=\"width: " ++ toString (imageAttributes.width + 20) ++ "px; margin-left:auto, margin-right:auto; text-align: center;\""


imageFloatRightStyle imageAttributes =
    "style=\"float: right; width: " ++ toString (imageAttributes.width + 20) ++ "px; margin: 0 0 7.5px 10px; text-align: center;\""


imageFloatLeftStyle imageAttributes =
    "style=\"float: left; width: " ++ toString (imageAttributes.width + 20) ++ "px; margin: 0 10px 7.5px 0; text-align: center;\""


handleCenterImage url label imageAttributes =
    let
        width =
            imageAttributes.width
    in
    Html.div [ imageCenterStyle imageAttributes ] [ Html.img url imageAttributes, "<br>", label ]


handleFloatedImageRight url label imageAttributes =
    let
        width =
            imageAttributes.width

        imageRightDivLeftPart width =
            "<div style=\"float: right; width: " ++ toString (width + 20) ++ "px; margin: 0 0 7.5px 10px; text-align: center;\">"
    in
    imageRightDivLeftPart width ++ "<img src=\"" ++ url ++ "\" width=" ++ toString width ++ "><br>" ++ label ++ "</div>"


handleFloatedImageLeft url label imageAttributes =
    let
        width =
            imageAttributes.width

        imageLeftDivLeftPart width =
            "<div style=\"float: left; width: " ++ toString (width + 20) ++ "px; margin: 0 10px 7.5px 0; text-align: center;\">"
    in
    imageLeftDivLeftPart width ++ "<img src=\"" ++ url ++ "\" width=" ++ toString width ++ "><br>" ++ label ++ "</div>"


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
