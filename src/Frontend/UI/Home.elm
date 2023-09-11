module Frontend.UI.Home exposing (..)

import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Html.Styled as HS 
import Html.Styled.Attributes as HSA
import Frontend.UI.DataPanel as DataPanel
import Frontend.UI.GameBoard as GameBoard

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
            , TW.items_center
            , TW.overflow_x_clip
            , TW.p_1
            ]
        ]
        [ dataPanel model
        , gameArea model            
        ]

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
            , TW.p_1    
            ]            
        ]
        [ HS.text "data panel" 
        , DataPanel.root model
        ]

gameArea : Types.FrontendModel -> HS.Html Types.FrontendMsg
gameArea model =
    HS.div
        [ HSA.css
            [ TW.w_8over12 
            , TW.box_border
            , TW.border_solid
            , TW.h_full      
            , TW.p_1      
            , TW.flex
            , TW.flex_col       
            ]            
        ]
        [ HS.text "game area" 
        , GameBoard.root model.board
        ]