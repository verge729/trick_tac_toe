module Frontend.UI.Authentication exposing (..)

import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW 
import Types
import Types.Button as Button

type alias AuthData =
    { target : Maybe String 
    , handler : String -> Types.FrontendMsg
    , placeholder : String
    }

root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    let
        handler_data = 
            { target = model.login_register_handle
            , handler = Types.FillHandler
            , placeholder = "Handler"            
            }

        keyphrase_data =
            { target = model.login_register_keyphrase
            , handler = Types.FillKeyphrase
            , placeholder = "Keyphrase"                
            }
    in 
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.flex_col
            , TW.w_1over2
            , TW.justify_center
            , TW.items_center
            , TW.p_6
            , TW.h_full
            ]            
        ]
        [ title
        , elementInputText handler_data (Just "* Do not use your real name *")
        , elementInputText keyphrase_data Nothing
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.flex
                , TW.flex_row 
                , TW.w_1over3 
                , TW.my_3                 
                ]                
            ]
            [ Button.button "Login" Types.Login Button.Regular
            , Button.button "Register" Types.Register Button.Regular           
            ]   
        , error model.m_error_message      
        ]

error : Maybe String -> HS.Html Types.FrontendMsg
error m_str =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_1over3
            , TW.h_fit
            , TW.flex
            , TW.flex_col 
            , TW.justify_center
            , TW.items_center  
            , TW.text_color TW.red_500          
            ]            
        ]
        [ HS.text <| Maybe.withDefault "" m_str            
        ]

title : HS.Html Types.FrontendMsg
title =
    HS.h1
        [ HSA.css
            [ TW.box_border
            , TW.w_fit
            , TW.h_fit
            , TW.flex
            , TW.flex_col 
            , TW.justify_center
            , TW.items_center  
            , TW.text_6xl          
            ]            
        ]
        [ HS.text "Trick Tac Toe"            
        ]

elementInputText : AuthData -> Maybe String -> HS.Html Types.FrontendMsg
elementInputText { target, handler, placeholder } m_notice =
    let
        input =
            case target of
                Just t ->
                    t

                Nothing ->
                    ""
    in
    HS.div
        [ HSA.css   
            [ TW.box_border
            , TW.w_1over3
            , TW.h_fit
            , TW.flex
            , TW.flex_col 
            -- , TW.justify_center
            , TW.items_center            
            ]            
        ]
        [ HS.input
            [ HSA.css
                [ TW.box_border
                , TW.w_full
                , TW.h_10
                -- , TW.justify_center
                -- , TW.items_center
                , TW.my_1
                ]
            , HSA.placeholder placeholder
            , HSA.value input
            , HSE.onInput handler
            ]
            [ 
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.flex
                , TW.items_center 
                , TW.text_sm                  
                ]                
            ]
            [ HS.text <| Maybe.withDefault "" m_notice                
            ]
        ]
