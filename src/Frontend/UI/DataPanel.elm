module Frontend.UI.DataPanel exposing (..)

import Types
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Types.Coordinates as Coordinates
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types.Player as Player
import Types.Victory as Victory
import Types.Ultimate.Board as UltimateBoard
import Array
import Types.Board as Board
import Types.SectorAttribute as SectorAttribute
import Types.Events as Events

root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.overflow_auto
            , TW.overflow_x_clip                
            ]            
        ]
        [ sectionTitle "Path to Victory"
        , pathToVictory model.path_to_victory
        , sectionTitle "Coordinates"
        , coordinates model.current_coordinate model.next_coordinate_low model.next_coordinate_mid
        , sectionTitle "Current Player"
        , currentPlayer model.current_player
        -- , sectionTitle "Focused Board" 
        -- , focusedBoard model.board model.current_coordinate   
        , sectionTitle "Event log"
        , eventsRegular model.list_events
        ]

sectionTitle : String -> HS.Html Types.FrontendMsg
sectionTitle title =
    HS.h3
        []
        [ HS.div
            []
            [ HS.text title                
            ]            
        ]

eventsRegular : List Events.Event -> HS.Html Types.FrontendMsg
eventsRegular list_events =
    let
        events =
            List.map (\event ->
                    HS.div
                        [ HSA.css
                            [ TW.box_border
                            , TW.m_2                    
                            ]                    
                        ]
                        [ HS.text <| Events.toStringEvent event                    
                        ]
                ) list_events  
     
    in
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.m_2                
            ]            
        ]
        events

focusedBoard : Board.Board -> Maybe Coordinates.Coordinates -> HS.Html Types.FrontendMsg
focusedBoard board m_coordinate =
    HS.div
        [] 
        (case board of
            Board.Ultimate board_ultimate ->
                (case m_coordinate of
                    Just coordinate ->
                            case Array.get (Coordinates.toIntSector coordinate.mid) board_ultimate of
                                Just sector ->
                                    List.map (\entry ->
                                        HS.div
                                            [ HSA.css
                                                [ TW.box_border
                                                , TW.m_2                                                    
                                                ]                                                
                                            ]
                                            [ HS.div 
                                                [] 
                                                [ HS.text <| "Coordinate : " ++ (Coordinates.toStringSector entry.coordinate)                                                
                                                ]
                                            , HS.div
                                                []
                                                [ HS.text <| "State : " ++ (SectorAttribute.toStringState entry.state)
                                                ]
                                            ]
                                    ) (Array.toList sector.board)

                                Nothing ->
                                    [ HS.text "No board selected"                    
                                    ]
                            
                    
                    Nothing ->
                        [ HS.text "No board selected (lacking coordinates)"                    
                        ]
                )
            _ ->
                [ HS.text "No board selected (incompatiable board)"                    
                ]
        )

pathToVictory : Victory.PathToVictory -> HS.Html Types.FrontendMsg
pathToVictory path_to_victory =
    HS.div
        []
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text <| Victory.toStringPathToVictory path_to_victory
            ]
        ]

currentPlayer : Player.Player -> HS.Html Types.FrontendMsg
currentPlayer player =
    HS.div
        []
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Username: "
            , HS.text player.username
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Icon: "
            , HS.text player.icon
            ]
        ]

coordinates : Maybe Coordinates.Coordinates -> Maybe Coordinates.Sector -> Maybe Coordinates.Sector -> HS.Html Types.FrontendMsg
coordinates m_current m_next_low m_next_mid =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full                
            ]            
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Current: "
            , HS.text <| Maybe.withDefault "No Coordinates selected" <|
                Maybe.map Coordinates.toStringCoordinates m_current
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Next low: "
            , HS.text <| Maybe.withDefault "No Coordinates selected" <|
                Maybe.map Coordinates.toStringSector m_next_low
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Next mid: "
            , HS.text <| Maybe.withDefault "No Coordinates selected" <|
                Maybe.map Coordinates.toStringSector m_next_mid
            ]
        ]            
        