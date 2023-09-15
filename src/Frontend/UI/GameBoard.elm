module Frontend.UI.GameBoard exposing (..)

import Array
import Css
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Storage.Game as StorageGame
import Types.Storage.User as User
import Types.Ultimate.Sector as UltimateSector
import Types.Victory as Victory


root : User.User -> StorageGame.Game -> HS.Html Types.FrontendMsg
root logged_in ({ board, current_coordinate, path_to_victory } as game) =
    let
        main_view =
            case ( board, current_coordinate ) of
                ( Board.Ultimate data, Just coordinates ) ->
                    case coordinates of
                        Coordinates.Ultimate coords ->
                            let
                                matrix =
                                    { top = Array.slice 0 3 data
                                    , middle = Array.slice 3 6 data
                                    , bottom = Array.slice 6 9 data
                                    }
                            in
                            boardUltimate matrix (Just coords) path_to_victory

                        _ ->
                            HS.div
                                []
                                [ HS.text "No board selected" ]

                ( Board.Ultimate data, Nothing ) ->
                    let
                        matrix =
                            { top = Array.slice 0 3 data
                            , middle = Array.slice 3 6 data
                            , bottom = Array.slice 6 9 data
                            }
                    in
                    boardUltimate matrix Nothing path_to_victory

                ( Board.Regular data, _ ) ->
                    let
                        matrix =
                            { top = Array.slice 0 3 data
                            , middle = Array.slice 3 6 data
                            , bottom = Array.slice 6 9 data
                            }
                    in
                    boardRegular matrix path_to_victory False

                _ ->
                    HS.div
                        []
                        [ HS.text "No board selected to show" ]

        not_your_turn_mask =
            if logged_in.id == game.current_player.id then
                HS.div [] []

            else
                jammerMask

        ( victory_view, victory_attrs, jammer_mask ) =
            case path_to_victory of
                Victory.Unacheived ->
                    ( HS.div [] []
                    , []
                    , HS.div [] []
                    )

                Victory.Acheived player ->
                    ( HS.div
                        [ HSA.css
                            [ TW.box_border
                            , TW.flex
                            , TW.justify_center
                            , TW.items_center
                            ]
                        ]
                        [ HS.h2
                            []
                            [ HS.text <| player.handle ++ " has won the game!"
                            ]
                        ]
                    , [ TW.border_solid
                      , TW.border_4
                      ]
                    , jammerMask
                    )
    in
    HS.div
        [ HSA.css
            (List.append
                [ TW.box_border
                , TW.relative
                ]
                victory_attrs
            )
        ]
        [ victory_view
        , main_view
        , jammer_mask
        , not_your_turn_mask
        ]



{- ANCHOR ultimate board -}


boardUltimate : Board.BoardRows Board.UltimateBoard -> Maybe Coordinates.Coordinates -> Victory.PathToVictory -> HS.Html Types.FrontendMsg
boardUltimate data m_current_coordinate path_to_victory =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.absolute
            , TW.h_fit
            , TW.w_fit
            , TW.relative
            ]
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.h_fit
                , TW.w_fit
                , TW.flex
                , TW.flex_col
                , TW.justify_center
                , TW.items_center
                , TW.z_20
                ]
            ]
            [ viewRowUltimate (Array.toList <| data.top) m_current_coordinate
            , viewRowUltimate (Array.toList <| data.middle) m_current_coordinate
            , viewRowUltimate (Array.toList <| data.bottom) m_current_coordinate
            ]
        ]


viewRowUltimate : List UltimateSector.Sector -> Maybe Coordinates.Coordinates -> HS.Html Types.FrontendMsg
viewRowUltimate list_board m_current_coordinate =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.h_fit
            , TW.w_fit
            , TW.flex
            , TW.justify_center
            , TW.items_center
            , TW.z_20
            ]
        ]
        (List.map
            (\board ->
                let
                    is_focused =
                        case m_current_coordinate of
                            Just current_coordinate ->
                                current_coordinate.mid == board.coordinate

                            Nothing ->
                                True
                in
                viewSectorUltimate board is_focused
            )
            list_board
        )


viewSectorUltimate : UltimateSector.Sector -> Bool -> HS.Html Types.FrontendMsg
viewSectorUltimate sector focused_sector =
    let
        matrix =
            { top = Array.slice 0 3 sector.board
            , middle = Array.slice 3 6 sector.board
            , bottom = Array.slice 6 9 sector.board
            }

        higlight_or_mask =
            if focused_sector then
                selectedBackground

            else
                jammerMask
    in
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.relative
            , TW.w_full
            , TW.h_full
            , TW.flex
            , TW.items_center
            , TW.justify_center
            ]
        ]
        [ HS.div
            [ HSA.css
                (List.append
                    [ TW.box_border
                    , TW.w_full
                    , TW.h_full
                    , TW.border_solid
                    , TW.border_b_0
                    , TW.border_l_0
                    , TW.border_r_0
                    , TW.border_t_0
                    , TW.flex
                    , TW.items_center
                    , TW.justify_center
                    , TW.z_20
                    ]
                    (getSectorBorder sector.coordinate Coordinates.Mid)
                )
            ]
            [ boardRegularMidLayer matrix sector.state sector.coordinate focused_sector
            ]
        , higlight_or_mask
        ]


boardRegularMidLayer :
    Board.BoardRows Board.RegularBoard
    -> SectorAttribute.State
    -> Coordinates.Sector
    -> Bool
    -> HS.Html Types.FrontendMsg
boardRegularMidLayer data path_to_victory mid_coordinate is_focused =
    HS.div
        [ HSE.onMouseEnter <| Types.NextCoordinateMidHover (Just mid_coordinate)
        , HSE.onMouseLeave <| Types.NextCoordinateMidHover Nothing
        ]
        [ boardRegular data (Victory.toPathToVictoryState path_to_victory) is_focused
        ]



{- ANCHOR regular board -}


boardRegular : Board.BoardRows Board.RegularBoard -> Victory.PathToVictory -> Bool -> HS.Html Types.FrontendMsg
boardRegular data path_to_victory is_focused =
    let
        ( mask, opacity ) =
            case path_to_victory of
                Victory.Unacheived ->
                    ( HS.div [] []
                    , TW.opacity_100
                    )

                Victory.Acheived player ->
                    ( victoryMask player is_focused
                    , TW.opacity_30
                    )
    in
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.h_fit
            , TW.w_fit
            , TW.relative
            , TW.m_4
            ]
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.h_fit
                , TW.w_fit
                , TW.flex
                , TW.flex_col
                , TW.justify_center
                , TW.items_center
                , TW.relative
                , TW.z_20
                , opacity
                ]
            ]
            [ viewRowBase (Array.toList <| data.top) is_focused
            , viewRowBase (Array.toList <| data.middle) is_focused
            , viewRowBase (Array.toList <| data.bottom) is_focused
            ]
        , mask
        ]


viewRowBase : List Sector.Sector -> Bool -> HS.Html Types.FrontendMsg
viewRowBase list_sector is_focused =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.z_20
            ]
        ]
        (List.map (viewSector is_focused) list_sector)


viewSector : Bool -> Sector.Sector -> HS.Html Types.FrontendMsg
viewSector is_focused sector =
    let
        shared_portion =
            [ HSA.css
                [ TW.box_border
                , TW.w_11over12
                , TW.h_5over6
                , TW.flex
                , TW.items_center
                , TW.justify_center
                , TW.m_2
                , Css.cursor Css.pointer
                ]
            , HSE.onMouseEnter <| Types.NextCoordinateLowHover (Just sector.coordinate)
            , HSE.onMouseLeave <| Types.NextCoordinateLowHover Nothing
            ]

        div_sector =
            case sector.state of
                SectorAttribute.Claimed player ->
                    HS.div
                        shared_portion
                        [ HS.div
                            [ HSA.css
                                [ TW.box_border
                                ]
                            ]
                            [ HS.text player.icon
                            ]
                        ]

                _ ->
                    HS.div
                        ((HSE.onClick <| Types.ClaimSector sector) :: shared_portion)
                        []
    in
    HS.div
        [ HSA.css
            (List.append
                [ TW.box_border
                , TW.w_20
                , TW.h_20
                , TW.border_solid
                , TW.border_b_0
                , TW.border_l_0
                , TW.border_r_0
                , TW.border_t_0
                , TW.flex
                , TW.items_center
                , TW.justify_center
                ]
                (getSectorBorder sector.coordinate Coordinates.Low)
            )
        ]
        [ div_sector
        ]



{- ANCHOR helpers -}


selectedBackground : HS.Html Types.FrontendMsg
selectedBackground =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.h_full
            , TW.w_full
            , TW.bg_color TW.white
            , TW.bg_opacity_10
            , TW.z_0
            , TW.absolute
            ]
        ]
        []


jammerMask : HS.Html Types.FrontendMsg
jammerMask =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.h_full
            , TW.w_full
            , TW.bg_color TW.black
            , TW.absolute
            , TW.bg_opacity_20
            , TW.z_40
            , TW.top_0
            ]
        ]
        []


victoryMask : Player.Player -> Bool -> HS.Html Types.FrontendMsg
victoryMask player is_focused =
    let
        attrs =
            if is_focused then
                [ TW.opacity_20
                , TW.z_0
                ]

            else
                [ TW.z_30
                ]
    in
    HS.div
        [ HSA.css
            (List.append
                attrs
                [ TW.box_border
                , TW.w_full
                , TW.h_full
                , TW.bg_color TW.white
                , TW.absolute
                , TW.bottom_0
                , TW.bg_opacity_25
                , TW.flex
                , TW.items_center
                , TW.justify_center
                ]
            )
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.text_9xl
                , TW.w_fit
                , TW.h_fit
                , TW.text_color TW.black
                ]
            ]
            [ HS.text player.icon
            ]
        ]


type alias BorderWidth =
    { top : Css.Style
    , right : Css.Style
    , bottom : Css.Style
    , left : Css.Style
    }


getSectorBorder : Coordinates.Sector -> Coordinates.Level -> List Css.Style
getSectorBorder sector level =
    let
        ( border_width, border_color ) =
            case level of
                Coordinates.Low ->
                    ( { top = TW.border_t
                      , right = TW.border_r
                      , bottom = TW.border_b
                      , left = TW.border_l
                      }
                    , TW.white
                    )

                Coordinates.Mid ->
                    ( { top = TW.border_t_4
                      , right = TW.border_r_4
                      , bottom = TW.border_b_4
                      , left = TW.border_l_4
                      }
                    , TW.stone_600
                    )
    in
    TW.border_color border_color
        :: (case sector of
                Coordinates.Zero ->
                    [ border_width.right
                    , border_width.bottom
                    ]

                Coordinates.One ->
                    [ border_width.bottom
                    ]

                Coordinates.Two ->
                    [ border_width.left
                    , border_width.bottom
                    ]

                Coordinates.Three ->
                    [ border_width.right
                    ]

                Coordinates.Four ->
                    -- this is center
                    []

                Coordinates.Five ->
                    [ border_width.left
                    ]

                Coordinates.Six ->
                    [ border_width.right
                    , border_width.top
                    ]

                Coordinates.Seven ->
                    [ border_width.top
                    ]

                Coordinates.Eight ->
                    [ border_width.left
                    , border_width.top
                    ]
           )
