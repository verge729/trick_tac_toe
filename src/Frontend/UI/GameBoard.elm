module Frontend.UI.GameBoard exposing (..)

import Types
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types.Board as Board
import Types.Sector as Sector
import Types.Coordinates as Coordinates
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Css
import Array

root : Board.Board -> HS.Html Types.FrontendMsg
root board =
    case board of
        Board.NotSelected ->
            HS.div
                []
                [ HS.text "No board selected" ]                    
                

        Board.Regular data ->
            boardRegular data

boardRegular : Board.RegularBoard -> HS.Html Types.FrontendMsg
boardRegular data =
    let
        row_one =
            Array.toList <| Array.slice 0 3 data
        row_two =
            Array.toList <| Array.slice 3 6 data
        row_three =
            Array.toList <| Array.slice 6 9 data
    in
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.h_full
            , TW.w_full   
            , TW.flex
            , TW.flex_col  
            , TW.justify_center
            , TW.items_center          
            ]
        ]
        [ viewRow row_one
        , viewRow row_two
        , viewRow row_three            
        ]

viewRow : List Sector.Sector -> HS.Html Types.FrontendMsg
viewRow list_sector =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex                
            ]            
        ]
        (List.map viewSector list_sector)

viewSector : Sector.Sector -> HS.Html Types.FrontendMsg
viewSector sector =
    HS.div
        [ HSA.css
            ( List.append
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
            [ HSA.css
                [ TW.box_border
                , TW.border_solid
                , TW.w_11over12  
                , TW.h_5over6 
                , TW.flex 
                , TW.items_center
                , TW.justify_center                
                ]  
            -- put these events into Free sections and not Claimed sections
            , HSE.onMouseEnter <| Types.NextCoordinateHover (Just sector.coordinate)
            , HSE.onMouseLeave <| Types.NextCoordinateHover Nothing  
            , HSE.onClick <| Types.ClaimSector sector       
            ]
            [ HS.div
                [ HSA.css
                    [ TW.box_border                  
                    ]                
                ]
                [ case sector.state of
                    Sector.Free ->
                        HS.text ""

                    Sector.Claimed player ->
                        HS.text player.icon                
                ]  
            ]          
        ]           

getSectorBorder : Coordinates.Sector -> List (Css.Style)
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

        Coordinates.Four -> -- this is center
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

        