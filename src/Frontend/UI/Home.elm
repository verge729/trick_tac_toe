module Frontend.UI.Home exposing (..)

import Frontend.UI.DataPanel as DataPanel
import Frontend.UI.GameBoard as GameBoard
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Navigation as Navigation
import Frontend.UI.Authentication as Authentication

root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    HS.div
        [ HSA.css
            [ TW.bg_color TW.black
            , TW.w_screen
            , TW.h_screen
            , TW.box_border
            , TW.text_color TW.white
            , TW.flex
            , TW.flex_col
            , TW.items_center
            , TW.overflow_x_clip
            , TW.p_1
            ]
        ]
        [ authLayer model
        ]

authLayer : Types.FrontendModel -> HS.Html Types.FrontendMsg
authLayer model =
    case model.view_full_area of
        Navigation.Authenicate ->
            authLayout model

        Navigation.Authenticated ->
            mainLayout model

authLayout : Types.FrontendModel -> HS.Html Types.FrontendMsg
authLayout model =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.h_full
            , TW.flex
            , TW.items_center
            , TW.justify_center            
            ]            
        ]
        [ Authentication.root model            
        ]

mainLayout : Types.FrontendModel -> HS.Html Types.FrontendMsg
mainLayout model =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.h_full
            , TW.flex
            , TW.flex_row
            , TW.items_center
            , TW.justify_center
            , TW.border_solid
            ]            
        ]
        [ dataPanel model
        , gameArea model           
        ]

titleBar : Types.FrontendModel -> HS.Html Types.FrontendMsg
titleBar model =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.h_fit
            , TW.border_solid
            , TW.border_color TW.blue_500                
            ]            
        ]
        [ HS.h1
            []
            [ HS.text "Trick Tac Toe"                
            ]            
        ]


dataPanel : Types.FrontendModel -> HS.Html Types.FrontendMsg
dataPanel model =
    HS.div
        [ HSA.css
            [ TW.w_4over12
            , TW.box_border
            -- , TW.border_l_0
            -- , TW.border_r
            -- , TW.border_t_0
            -- , TW.border_b_0
            , TW.h_full
            , TW.border_solid
            , TW.p_2
            , TW.text_right
            ]
        ]
        [ titleBar model
        , HS.text "data panel"
        , DataPanel.root model
        ]


gameArea : Types.FrontendModel -> HS.Html Types.FrontendMsg
gameArea model =
    HS.div
        [ HSA.css
            [ TW.w_8over12
            , TW.box_border
            , TW.h_full
            , TW.p_1
            , TW.flex
            , TW.flex_col
            , TW.border_solid
            ]
        ]
        [ HS.text "game area"
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.flex
                , TW.items_center
                , TW.justify_center
                , TW.h_full
                ]
            ]
            [ displayGameArea model
            ]
        ]

displayGameArea : Types.FrontendModel -> HS.Html Types.FrontendMsg
displayGameArea model =
    case model.view_game_area of
        Navigation.Authentication ->
            Authentication.root model

        Navigation.Game ->
            GameBoard.root model.board model.current_coordinate model.path_to_victory