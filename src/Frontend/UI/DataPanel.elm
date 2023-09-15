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
import Types.Navigation as Navigation
import Types.Button as Button
import Types.Storage.Game as StorageGame
import Types.Button as Button

root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.h_full  
            , TW.w_full        
            ]            
        ]
        [ panelLayer model
        ]

panelLayer : Types.FrontendModel -> HS.Html Types.FrontendMsg
panelLayer model =
    case model.view_data_panel of
        Navigation.Menu ->
            menu model

        Navigation.GameDetails ->
            gameDetailsArea model


menu : Types.FrontendModel -> HS.Html Types.FrontendMsg
menu model =
    let
        button_game_detail =
            case model.game of
                Just _ ->
                    Button.button "Game Details" (Types.DataPanelNavTo Navigation.GameDetails ) Button.Wide Button.Unselected
                    

                Nothing ->
                    HS.div [] []
    in 
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full 
            , TW.h_3over6
            , TW.space_y_2  
            , TW.justify_center 
            , TW.flex
            , TW.flex_col   
            , TW.items_center    
            ]            
        ]
        [ button_game_detail
        , Button.button "Create Game" (Types.GameViewAreaNavTo Navigation.CreateGame ) Button.Wide Button.Unselected
        , Button.button "Join Game" (Types.GameViewAreaNavTo Navigation.JoinGame ) Button.Wide Button.Unselected
        , Button.button (gameCount "View Active Games" model.user_games.active) (Types.GameViewAreaNavTo Navigation.GameListActive ) Button.Wide Button.Unselected
        , Button.button (gameCount "View Waiting Games" model.user_games.waiting ) (Types.GameViewAreaNavTo Navigation.GameListWaiting ) Button.Wide Button.Unselected
        , Button.button (gameCount "View Completed Games" model.user_games.finished ) (Types.GameViewAreaNavTo Navigation.GameListFinished ) Button.Wide Button.Unselected
        , Button.button "Help" (Types.GameViewAreaNavTo Navigation.Help ) Button.Wide Button.Unselected
        ]

gameCount : String -> List StorageGame.Game -> String
gameCount label list_games =
    label ++ " (" ++ (String.fromInt <| List.length list_games) ++ ")"


gameDetailsArea : Types.FrontendModel -> HS.Html Types.FrontendMsg
gameDetailsArea model =
    case model.game of
        Just game ->
            case game.player_two of
                Just player_two ->
                    let
                        opposing_player =
                            case model.user of
                                Just user ->
                                    if (Player.getPlayerFromUser model.player_one model.player_two user) == model.player_one then
                                        model.player_two
                                    else
                                        model.player_one

                                Nothing ->
                                    model.player_two
                    in
                    HS.div
                        [ HSA.css
                            [ TW.box_border
                            , TW.w_full 
                            , TW.h_5over6
                            , TW.space_y_2  
                            , TW.flex
                            , TW.flex_col   
                            , TW.items_end  
                            , TW.overflow_clip 
                            ]            
                        ]
                        [ HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex  
                                , TW.items_center
                                , TW.justify_center
                                , TW.mt_4
                                ]
                                ]            
                            [ Button.button "Menu" (Types.DataPanelNavTo Navigation.Menu ) Button.Wide Button.Unselected
                            ]
                        , HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex
                                , TW.flex_col   
                                , TW.items_end   
                                ]            
                            ]
                            [ sectionTitle "Game details"  
                            , gameDetails opposing_player game              
                            ]
                        , HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex
                                , TW.flex_col   
                                , TW.items_end   
                                ]            
                            ]
                            [ sectionTitle "Turn details"   
                            , turnDetails model.current_player game  
                            ]  
                        , HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex
                                , TW.flex_col   
                                , TW.items_end  
                                , TW.overflow_clip
                                ]            
                            ]
                            [ sectionTitle "Event log"   
                            , eventsRegular game.event_log
                            ]      
                        ]
                Nothing ->
                    HS.div
                        [ HSA.css
                            [ TW.box_border
                            , TW.w_full 
                            , TW.h_5over6
                            , TW.space_y_2  
                            , TW.flex
                            , TW.flex_col   
                            , TW.items_end  
                            , TW.overflow_clip 
                            ]            
                        ]
                        [ HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex
                                , TW.flex_col   
                                , TW.items_end   
                                ]            
                            ]
                            [ Button.button "Menu" (Types.DataPanelNavTo Navigation.Menu ) Button.Regular Button.Unselected
                            ]
                        , HS.div
                            [ HSA.css
                                [ TW.box_border
                                , TW.w_full 
                                , TW.flex
                                , TW.flex_col   
                                , TW.items_end  
                                , TW.overflow_clip
                                ]            
                            ]
                            [ HS.text "Missing player two"                        
                            ]
                        ]


        Nothing ->
            HS.div
                [ HSA.css
                    [ TW.box_border
                    , TW.w_full 
                    , TW.h_5over6
                    , TW.space_y_2  
                    , TW.flex
                    , TW.flex_col   
                    , TW.items_end  
                    , TW.overflow_clip 
                    ]            
                ]
                [ HS.div
                    [ HSA.css
                        [ TW.box_border
                        , TW.w_full 
                        , TW.flex
                        , TW.flex_col   
                        , TW.items_end   
                        ]            
                    ]
                    [ Button.button "Menu" (Types.DataPanelNavTo Navigation.Menu ) Button.Regular Button.Unselected
                    ]
                , HS.div
                    [ HSA.css
                        [ TW.box_border
                        , TW.w_full 
                        , TW.flex
                        , TW.flex_col   
                        , TW.items_end  
                        , TW.overflow_clip
                        ]            
                    ]
                    [ HS.text "No game selected"                        
                    ]
                ]
    

sectionTitle : String -> HS.Html Types.FrontendMsg
sectionTitle title =
    HS.h3
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            -- , TW.border_solid 
            , TW.my_1     
            ]            
        ]
        [ HS.div
            []
            [ HS.text title                
            ]            
        ]

gameDetails : Player.Player -> StorageGame.Game -> HS.Html Types.FrontendMsg
gameDetails opposing game =
    HS.div 
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.flex_col 
            , TW.items_end  
            , TW.w_full
            -- , TW.border_solid                     
            ]                    
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.ml_2  
                , TW.flex                
                ]                        
            ]
            [ HS.text <| "Current game: " ++ game.game_name                    
            ]  
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.ml_2  
                , TW.flex                
                ]                        
            ]
            [ HS.text <| "Opponent: " ++ opposing.handle                    
            ]         
        ]


turnDetails : Player.Player -> StorageGame.Game -> HS.Html Types.FrontendMsg
turnDetails current_player game =
    case game.player_two of
        Just player_two ->
            HS.div
                [ HSA.css
                    [ TW.box_border
                    , TW.flex
                    , TW.flex_col 
                    , TW.items_end  
                    , TW.w_full
                    -- , TW.border_solid                     
                    ]                    
                ]
                [ HS.div
                    [ HSA.css
                        [ TW.box_border
                        , TW.ml_2  
                        , TW.flex                
                        ]                        
                    ]
                    [ HS.text <| "Turn: " ++ (String.fromInt game.turn)                    
                    ]   
                , HS.div  
                    [ HSA.css
                        [ TW.box_border
                        , TW.flex
                        , TW.flex_col 
                        , TW.items_end  
                        , TW.w_full                    
                        ]                    
                    ]
                    [ HS.text <| "Current Player: " ++ current_player.handle                    
                    ]               
                ]
            
        Nothing ->
            HS.div [] []


eventsRegular : List Events.Event -> HS.Html Types.FrontendMsg
eventsRegular list_events =
    let
        events =
            List.map (\event ->
                let
                    base_event_attrs =
                        [ TW.box_border
                        , TW.m_2                    
                        ] 

                    altered_event_attrs =
                        case event.event of
                            Events.Trick _ ->
                                (TW.text_color TW.red_400 :: base_event_attrs)

                            _ ->
                                base_event_attrs

                in
                HS.div
                    [ HSA.css
                        altered_event_attrs                   
                    ]
                    [ HS.text <| Events.toStringEvent event                    
                    ]
                ) list_events  
     
    in
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.overflow_auto
            -- , TW.overflow_y_scroll 
            , TW.h_5over6              
            ]            
        ]
        events
