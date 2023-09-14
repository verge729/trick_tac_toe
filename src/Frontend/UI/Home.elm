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
import Types.Storage.User as User
import Types.Storage.Connectivity exposing (Connectivity)
import Types.Storage.Connectivity as Connectivity

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
        Navigation.Authenticate ->
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

userCard : Maybe User.User -> Int -> HS.Html Types.FrontendMsg
userCard m_user num_games =
    case m_user of
        Just user ->
            let
                connection_color =
                    case user.state of
                        Connectivity.Connected _ ->
                            TW.green_500

                        Connectivity.Disconnected ->
                            TW.red_500

                connection =
                    HS.div
                        [ HSA.css
                            [ TW.box_border
                            , TW.bg_color connection_color
                            , TW.w_3
                            , TW.h_3 
                            , TW.rounded_2xl                                
                            ]                            
                        ]
                        []
            in 
            HS.div
                [ HSA.css
                    [ TW.box_border
                    , TW.w_full
                    , TW.h_fit
                    , TW.border_solid
                    , TW.border_color TW.blue_500 
                    , TW.flex 
                    , TW.flex_col
                    , TW.space_x_2 
                    , TW.items_end  
                    , TW.p_2                    
                    ]            
                ]
                [ HS.div
                    [ HSA.css
                        [ TW.box_border
                        , TW.flex   
                        , TW.space_x_2  
                        , TW.items_center
                        , TW.justify_center                                    
                        ]                        
                    ]
                    [ HS.div
                        []
                        [ HS.text user.handle                
                        ] 
                    , connection 
                    ]   
                , HS.div
                    [ HSA.css
                        [ TW.flex                           
                        ]                        
                    ]
                    [ HS.text <| "Participating in " ++ (String.fromInt num_games) ++ " games"                
                    ]         
                ]
        
        Nothing ->
            HS.div [] []

dataPanel : Types.FrontendModel -> HS.Html Types.FrontendMsg
dataPanel model =
    HS.div
        [ HSA.css
            [ TW.w_3over12
            , TW.box_border
            , TW.border_l_0
            , TW.border_r
            , TW.border_t_0
            , TW.border_b_0
            , TW.h_full
            , TW.border_solid
            , TW.p_2
            , TW.text_right
            , TW.flex
            , TW.flex_col
            ]
        ]
        [ titleBar model
        , userCard model.user (List.length model.user_games)
        , HS.text "data panel"
        , DataPanel.root model
        ]


gameArea : Types.FrontendModel -> HS.Html Types.FrontendMsg
gameArea model =
    HS.div
        [ HSA.css
            [ TW.w_9over12
            , TW.box_border
            , TW.h_full
            , TW.p_1
            , TW.flex
            , TW.flex_col
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
        Navigation.GameList ->
            Authentication.root model

        Navigation.Game ->
            GameBoard.root model.board model.current_coordinate model.path_to_victory

        Navigation.CreateGame ->
            HS.div [] []

        Navigation.Help ->
            HS.div [] []

        Navigation.NotIdentified ->
            HS.div [] []

        Navigation.JoinGame ->
            HS.div [] []

