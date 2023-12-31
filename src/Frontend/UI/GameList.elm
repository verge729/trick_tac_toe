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
import Types.Victory as Victory


root : User.User -> List StorageGame.Game -> HS.Html Types.FrontendMsg
root logged_in_user list_games =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_11over12
            , TW.flex
            , TW.flex_wrap
            , TW.items_center
            , TW.justify_center
            , TW.h_fit
            , TW.overflow_auto
            ]
        ]
        (List.map (gameCardLayer logged_in_user) list_games)


gameCardLayer : User.User -> StorageGame.Game -> HS.Html Types.FrontendMsg
gameCardLayer logged_in_user game =
    case game.path_to_victory of
        Victory.Acheived player ->
            let
                victor =
                    case game.player_two of
                        Just player_two ->
                            if player.handle == player_two.handle then
                                player_two

                            else
                                game.player_one

                        Nothing ->
                            logged_in_user
            in
            gameCardGameOver logged_in_user victor game

        Victory.Unacheived ->
            gameCard logged_in_user game


gameCardGameOver : User.User -> User.User -> StorageGame.Game -> HS.Html Types.FrontendMsg
gameCardGameOver logged_in_user victor game =
    let
        base_css =
            [ TW.box_border
            , TW.flex
            , TW.flex_col
            , TW.p_3
            , TW.items_start
            , TW.w_4over12
            , TW.m_2
            , TW.bg_color TW.stone_600
            , Css.cursor Css.pointer
            ]

        ( updated_css, phrase ) =
            if logged_in_user.id == victor.id then
                ( List.append
                    base_css
                    [ TW.bg_color TW.green_500
                    , TW.bg_opacity_40
                    ]
                , gameOverPhrase "YOU" (game.turn - 1) "Way to go!"
                )

            else
                ( List.append
                    base_css
                    [ TW.bg_color TW.red_500
                    , TW.bg_opacity_40
                    ]
                , gameOverPhrase victor.handle (game.turn - 1) "Lame sauce."
                )
    in
    HS.div
        [ HSA.css updated_css
        , HSE.onClick <| Types.SelectGame game.id
        ]
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
                [ HS.text phrase
                ]
            , viewOpponent logged_in_user game.player_one game.player_two game.id
            ]
        ]


gameOverPhrase : String -> Int -> String -> String
gameOverPhrase victor_handle num_turns phrase =
    victor_handle ++ " won in " ++ String.fromInt num_turns ++ " turns! " ++ phrase


gameCard : User.User -> StorageGame.Game -> HS.Html Types.FrontendMsg
gameCard logged_in_user game =
    let
        base_css =
            [ TW.box_border
            , TW.flex
            , TW.flex_col
            , TW.p_3
            , TW.items_start
            , TW.w_4over12
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

        current_player =
            if logged_in_user.id == game.current_player.id then
                "YOU"

            else
                game.current_player.handle
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
                [ HS.text <| "Turn " ++ String.fromInt game.turn ++ " and waiting on " ++ current_player ++ "!"
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


currentPlayer : User.User -> HS.Html Types.FrontendMsg
currentPlayer user =
    HS.div
        []
        [ HS.text <| "It's " ++ user.handle ++ "'s turn"
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
                    , TW.items_center
                    ]
                ]
                [ HS.div
                    [ HSA.css
                        [ TW.mr_2
                        ]
                    ]
                    [ HS.text user.handle
                    ]
                , connection
                ]

        Nothing ->
            HS.div
                []
                [ HS.text <| "No opponent. Invite someone with code " ++ StorageGame.getId game_id
                ]
