module Frontend.UI.Help exposing (..)

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
import Types.Storage.User as StorageUser

root : Maybe StorageUser.User -> HS.Html Types.FrontendMsg
root m_user = 
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
        [ dataPanel m_user
        , informationArea         
        ]

titleBar : HS.Html Types.FrontendMsg
titleBar  =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.border_l_0
            , TW.border_r_0
            , TW.border_t_0
            , TW.border_b
            , TW.border_solid 
            , TW.pr_2             
            ]            
        ]
        [ HS.h1
            []
            [ HS.text "What is Trick Tac Toe?"                
            ]            
        ]

dataPanel : Maybe StorageUser.User -> HS.Html Types.FrontendMsg
dataPanel m_user =
    let
        target =
            case m_user of
                Just user ->
                    Navigation.Authenticated

                Nothing ->
                    Navigation.Authenticate
    in
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
            , TW.overflow_clip
            , TW.items_end
            ]
        ]
        [ titleBar 
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.m_4
                , TW.w_full                    
                ]                
            ]
            [ Button.button "Go back" (Types.FullViewNavTo target) Button.Wide Button.Unselected 
            ]
        ]

informationArea : HS.Html Types.FrontendMsg
informationArea =
    HS.div
        [ HSA.css
            [ TW.w_9over12
            , TW.box_border
            , TW.h_full
            , TW.p_4
            , TW.flex
            , TW.flex_col
            , TW.items_center
            , TW.overflow_auto
            ]
        ]
        [ HS.div
            [ HSA.css
                [ TW.box_border
                , TW.flex
                , TW.flex_col
                , TW.justify_center
                , TW.h_full
                , TW.w_9over12
                ]
            ]
            [ sectionTitle "Ultimate Tic Tac Toe"
            , explainUltimate
            , sectionTitle "Trick Tic Tac Toe"
            , explainTrick
            , sectionTitle "About this game"
            , explainGame
            ]
        ]


sectionTitle : String -> HS.Html Types.FrontendMsg
sectionTitle title =
    HS.h2
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.mb_0    
            ]            
        ]
        [ HS.div
            []
            [ HS.text title   
            ]
        ]             

explainGame : HS.Html Types.FrontendMsg
explainGame =
    HS.div
        []
        [ HS.p
            [ HSA.css
                [ TW.box_border
                , TW.w_full  
                ]                
            ]
            [ paragraph "This game does not collect personal information. You are asked to provide a handler and keyphrase so your games can be connected to you. This also allows you to play the game with friends."
            , paragraph "If you want to play a game with somone you know, after logging in, you will see a \"Create a game\" button where you can host a game and give it a name and choose if it is a classic or Ultimate game. You will then see a code on the Game Card for the new game. Share this code with a friend."
            , paragraph "To join a game, you will need to enter a join code in the \"Join a game\" page. This can be found by clicking the \"Join a game\" button after logging in."
            , paragraph "You will know if your opponent is online by the colored dot located by their handle on the Game Card for your game with them. Green means they are online. Red means they are offline."
            , paragraph "Your opponent will recieve your turn as soon as you claim a sector, so be careful to not click prematurely!"
            , paragraph "There is not restriction on how many games you can participate in at once."
            , paragraph <| "If you have any feedback, please email the feedback to " ++ Types.supportEmail ++ " ."
            ]            
        ]


explainUltimate : HS.Html Types.FrontendMsg
explainUltimate =
    HS.div
        []
        [ HS.p
            [ HSA.css
                [ TW.box_border
                , TW.w_full  
                ]                
            ]
            [ paragraph "The game of Ultimate Tic Tac Toe takes the classic game of Tic Tac Toe to a new level. Instead of a 9 sector game, there are now 81 sectors to claim and more space to outwit your opponent."
            , paragraph "The way to win a game of Ultimate Tic Tac Toe is to claim three sectors that connect to make a line. Horizontal, vertical, or diagonal. It;s just not as easy to claim a sector as it is in a regular game of Tic Tac Toe."
            , paragraph "To claim a sector, you must win the Tic Tac Toe game within that sector. That's all fine and dandy, but how do you get to the other sectors on your way to victory? It's simple: the regular Tic Tac Toe board acts as a navigation device."
            , paragraph "What do I mean by that? Well, whatever mini-sector you claim will determine which greater-sector the next move will be played. So, if you are in the bottom-left greater-sector and you claim the top-right mini sector, your opponent's next move will be in the top-right greater sector!"
            , paragraph "This mechanic will allow you to try to outwit your opponent by directing their moves! If that sounds confusing, don't worry. By the time you are part way through the first game, you'll have the hand of it."
            , paragraph "This game is also designed to keep track of which sector is playable each turn."                    
            ]            
        ]

explainTrick : HS.Html Types.FrontendMsg
explainTrick =
    HS.div
        []
        [ HS.p
            [ HSA.css
                [ TW.box_border
                , TW.w_full
                ]                
            ]
            [ paragraph "Trick Tac Toe offers a twist on the classic and Ultimate versions of Tic Tac Toe. When each game is created, a random amount of \"Tricks\" are placed throughout the board. These are designed to change the environment of the board. The best part is that you will only find a Trick after you claim a tricked-out mini-sector!"
            , paragraph "These tricks can do anything from making a claim on a mini-sector disappear to making the board think you claimed a different mini-sector than you intended. Your opponent may trigger a trick, turning the game in your favor! Or maybe you'll trigger one and hand the game to your opponent..."

            ]
        ]


paragraph : String -> HS.Html Types.FrontendMsg
paragraph content =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_full
            , TW.my_3
            ]            
        ]
        [ HS.text content            
        ]