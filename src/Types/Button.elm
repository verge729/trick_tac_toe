module Types.Button exposing (..)

import Types
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW 
import Tailwind.Utilities as TW

type Width 
    = Wide
    | Regular

button : String -> Types.FrontendMsg -> Width -> HS.Html Types.FrontendMsg
button label handler width =
    let
        b_width =
            case width of
                Wide ->
                    TW.w_11over12

                Regular ->
                    TW.w_1over2
    in 
    HS.button
        [ HSA.css   
            [ TW.box_border
            , b_width 
            , TW.h_8
            , TW.mx_3               
            ] 
        , HSE.onClick handler           
        ]
        [ HS.text label
        ]