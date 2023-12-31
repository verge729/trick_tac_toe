module Types.Button exposing (..)

import Css
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types


type Width
    = Wide
    | Regular
    | Small


type BackgroundColor
    = Selected
    | Unselected


button : String -> Types.FrontendMsg -> Width -> BackgroundColor -> HS.Html Types.FrontendMsg
button label handler width bg_color =
    let
        b_width =
            case width of
                Wide ->
                    TW.w_11over12

                Regular ->
                    TW.w_1over2

                Small ->
                    TW.w_1over4

        b_color =
            case bg_color of
                Selected ->
                    TW.gray_700

                Unselected ->
                    TW.stone_600
    in
    HS.button
        [ HSA.css
            [ TW.box_border
            , b_width
            , TW.h_8
            , TW.mx_3
            , TW.bg_color b_color
            , TW.text_color TW.white
            , Css.cursor Css.pointer
            ]
        , HSE.onClick handler
        ]
        [ HS.text label
        ]
