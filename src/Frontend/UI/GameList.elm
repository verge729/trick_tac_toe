module Frontend.UI.GameList exposing (..)

import Css
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Board as Board
import Types.Storage.Connectivity as Connectivity
import Types.Storage.Game as StorageGame
import Types.Storage.User as User


root : User.User -> List StorageGame.Game -> HS.Html Types.FrontendMsg
root logged_in_user list_games =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_10over12
            , TW.flex
            , TW.flex_wrap
            , TW.items_center
            , TW.justify_center
            ]
        ]
        (List.map (gameCard logged_in_user) list_games)


gameCard : User.User -> StorageGame.Game -> HS.Html Types.FrontendMsg
gameCard logged_in_user game =
    let
        base_css =
            [ TW.box_border
            , TW.flex
            , TW.flex_col
            , TW.p_3
            , TW.items_start
            , TW.w_5over12
            , TW.m_2
            , TW.bg_color TW.stone_600
            ]

        ( interactivity, updated_css ) =
            case game.player_two of
                Just _ ->
                    ( [ HSE.onClick <| Types.SelectGame game.id
                      ]
                    , List.append 
                        base_css 
                        [ Css.cursor Css.pointer                            
                        ]
                    )

                Nothing ->
                    ( []
                    , List.append 
                        base_css 
                        [ TW.bg_color TW.yellow_200
                        , TW.bg_opacity_40                         
                        ] 
                    )
    in
    HS.div
        (HSA.css updated_css :: interactivity)
        [ HS.h1
            [ HSA.css
                [ TW.m_2
                ]
            ]
            [ HS.text game.game_name
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.pl_4
                ]
            ]
            [ gameTypeView game.board
            , HS.div
                []
                [ HS.text <| "Turn " ++ String.fromInt game.turn
                ]
            , viewOpponent logged_in_user game.player_one game.player_two game.id
            ]
        ]


gameTypeView : Board.Board -> HS.Html Types.FrontendMsg
gameTypeView board =
    let
        board_type =
            case board of
                Board.NotSelected ->
                    "None selected"

                Board.Regular _ ->
                    "Regular"

                Board.Ultimate _ ->
                    "Ultimate"
    in
    HS.div
        []
        [ HS.text board_type
        ]


viewOpponent : User.User -> User.User -> Maybe User.User -> StorageGame.GameId -> HS.Html Types.FrontendMsg
viewOpponent logged_in player_one m_player_two game_id =
        case m_player_two of
            Just player_two ->
                let
                    user =
                        if logged_in.id == player_one.id then
                            player_two

                        else
                            player_one

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

            Nothing ->
                HS.div
                    []
                    [ HS.text <| "No opponent. Invite someone with code " ++ StorageGame.getId game_id
                    ]
