module Frontend.UI.GameBoard exposing (..)

import Array
import Css
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.Base.Sector as Sector
import Types.Victory as Victory
import Types.SectorAttribute as SectorAttribute
import Types.Ultimate.Sector as UltimateSector


root : Board.Board -> Victory.PathToVictory -> HS.Html Types.FrontendMsg
root board claimed_victory =
    case board of
        Board.NotSelected ->
            HS.div
                []
                [ HS.text "No board selected" ]

        Board.Regular data ->
            let
                matrix =
                    { top = Array.slice 0 3 data
                    , middle = Array.slice 3 6 data
                    , bottom = Array.slice 6 9 data
                    }
            in
            boardRegular matrix claimed_victory

        Board.Ultimate data ->
            let
                matrix =
                    { top = Array.slice 0 3 data
                    , middle = Array.slice 3 6 data
                    , bottom = Array.slice 6 9 data
                    }
            in
            boardUltimate matrix claimed_victory

boardUltimate : Board.BoardRows Board.UltimateBoard -> Victory.PathToVictory -> HS.Html Types.FrontendMsg
boardUltimate data claimed_victory =
    HS.div
        [ HSA.css
            [ TW.box_border
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
            [ viewRowUltimate (Array.toList <| data.top) 
            , viewRowUltimate (Array.toList <| data.middle) 
            , viewRowUltimate (Array.toList <| data.bottom) 
            ]
        ]

viewRowUltimate : List UltimateSector.Sector -> HS.Html Types.FrontendMsg
viewRowUltimate list_board =
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
        ( List.map (\board -> 
                viewSectorUltimate board 
            ) list_board
        )

viewSectorUltimate : UltimateSector.Sector -> HS.Html Types.FrontendMsg
viewSectorUltimate sector =
    let
        matrix =
            { top = Array.slice 0 3 sector.board
            , middle = Array.slice 3 6 sector.board
            , bottom = Array.slice 6 9 sector.board
            }

    in
    HS.div
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
                ]
                (getSectorBorder sector.coordinate)
            )
        ]
        [ boardRegularMidLayer matrix sector.state sector.coordinate          
        ]

boardRegularMidLayer : Board.BoardRows Board.RegularBoard -> SectorAttribute.State -> Coordinates.Sector -> HS.Html Types.FrontendMsg
boardRegularMidLayer data claimed_victory mid_coordinate =
    HS.div
        [ HSE.onMouseEnter <| Types.NextCoordinateMidHover (Just mid_coordinate)
        , HSE.onMouseLeave <| Types.NextCoordinateMidHover (Nothing)            
        ]
        [ boardRegular data (Victory.toPathToVictoryState claimed_victory)
        ]

boardRegular : Board.BoardRows Board.RegularBoard -> Victory.PathToVictory -> HS.Html Types.FrontendMsg
boardRegular data claimed_victory =
    let
        ( mask, opacity ) =
            case claimed_victory of
                Victory.Unacheived ->
                    ( HS.div [] []
                    , TW.opacity_100
                    )

                Victory.Acheived player ->
                    ( victoryMask player
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
                , TW.z_20
                , opacity
                ]
            ]
            [ viewRowBase (Array.toList <| data.top)
            , viewRowBase (Array.toList <| data.middle)
            , viewRowBase (Array.toList <| data.bottom)
            ]
        , mask
        ]


viewRowBase : List Sector.Sector ->  HS.Html Types.FrontendMsg
viewRowBase list_sector  =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            ]
        ]
        (List.map (viewSector ) list_sector)


viewSector : Sector.Sector -> HS.Html Types.FrontendMsg
viewSector sector =
    let
        ( interactions, icon ) =
            case sector.state of
                SectorAttribute.Free ->
                    ( [ HSE.onClick <| Types.ClaimSector sector
                      ]
                    , HS.text ""
                    )

                SectorAttribute.Claimed player ->
                    ( []
                    , HS.text player.icon
                    )
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
                (getSectorBorder sector.coordinate)
            )
        ]
        [ HS.div
            (List.append
                [ HSA.css
                    [ TW.box_border
                    , TW.w_11over12
                    , TW.h_5over6
                    , TW.flex
                    , TW.items_center
                    , TW.justify_center
                    ]
                , HSE.onMouseEnter <| Types.NextCoordinateLowHover (Just sector.coordinate)
                , HSE.onMouseLeave <| Types.NextCoordinateLowHover Nothing
                ]
                interactions
            )
            [ HS.div
                [ HSA.css
                    [ TW.box_border
                    ]
                ]
                [ icon
                ]
            ]
        ]


victoryMask : Player.Player -> HS.Html Types.FrontendMsg
victoryMask player =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.h_60
            , TW.bg_color TW.white
            , TW.absolute
            , TW.z_10
            , TW.bottom_0
            , TW.bg_opacity_25
            , TW.flex
            , TW.items_center
            , TW.justify_center
            ]
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


getSectorBorder : Coordinates.Sector -> List Css.Style
getSectorBorder sector =
    case sector of
        Coordinates.Zero ->
            [ TW.border_r
            , TW.border_b
            ]

        Coordinates.One ->
            [ TW.border_b
            ]

        Coordinates.Two ->
            [ TW.border_l
            , TW.border_b
            ]

        Coordinates.Three ->
            [ TW.border_r
            ]

        Coordinates.Four ->
            -- this is center
            []

        Coordinates.Five ->
            [ TW.border_l
            ]

        Coordinates.Six ->
            [ TW.border_r
            , TW.border_t
            ]

        Coordinates.Seven ->
            [ TW.border_t
            ]

        Coordinates.Eight ->
            [ TW.border_l
            , TW.border_t
            ]
