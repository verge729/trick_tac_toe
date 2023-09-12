module Frontend.UI.DataPanel exposing (..)

import Types
import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Types.Coordinates as Coordinates
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types.Player as Player
import Types.Victory as Victory

root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    HS.div
        []
        [ sectionTitle "Path to Victory"
        , pathToVictory model.path_to_victory
        , sectionTitle "Coordinates"
        , coordinates model.current_coordinate model.next_coordinate 
        , sectionTitle "Current Player"
        , currentPlayer model.current_player           
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

coordinates : Maybe Coordinates.Coordinates -> Maybe Coordinates.Coordinates -> HS.Html Types.FrontendMsg
coordinates m_current m_next =
    let
        (current_text, next_text) =
            case (m_current, m_next) of
                (Just current, Just next) ->
                    ( Just <| Coordinates.toStringCoordinates current
                    , Just <| Coordinates.toStringCoordinates next
                    )

                (Just current, Nothing) ->
                    ( Just <| Coordinates.toStringCoordinates current
                    , Nothing
                    )

                (Nothing, Just next) ->
                    ( Nothing
                    , Just <| Coordinates.toStringCoordinates next
                    )

                (Nothing, Nothing) ->
                    ( Nothing
                    , Nothing
                    )
    in
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
            , HS.text <| Maybe.withDefault "No Coordinates selected" current_text
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.w_10over12
                , TW.ml_2                    
                ]                
            ]
            [ HS.text "Next: "
            , HS.text <| Maybe.withDefault "No Coordinates selected" next_text
            ]
        ]            
        