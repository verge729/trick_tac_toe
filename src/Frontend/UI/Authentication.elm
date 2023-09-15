module Frontend.UI.Authentication exposing (..)

import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Button as Button
import Types.Navigation as Navigation


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
            [ Button.button "Login" Types.Login Button.Regular Button.Unselected
            , Button.button "Register" Types.Register Button.Regular Button.Unselected
            ]
        , Button.button "What is Trick Tac Toe?" (Types.FullViewNavTo Navigation.WhatIsThis) Button.Small Button.Unselected
        , error model.m_error_message
        , imageLinks
        , feedback
        ]


feedback : HS.Html Types.FrontendMsg
feedback =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.text_sm
            , TW.mt_4
            , TW.flex
            , TW.flex_col
            , TW.items_center
            , TW.justify_center
            ]
        ]
        [ HS.div [] [ HS.text <| "Please provide any feedback to" ]
        , HS.div [] [ HS.text Types.supportEmail ]
        ]


imageLinks : HS.Html Types.FrontendMsg
imageLinks =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.items_center
            , TW.justify_around
            , TW.w_3over12
            , TW.px_4
            ]
        ]
        [ HS.a
            [ HSA.href Types.githubRepo
            , HSA.target "_blank"
            ]
            [ HS.img
                [ HSA.src "/assets/images/github-mark-white.png"
                , HSA.css
                    [ TW.w_10
                    , TW.object_contain
                    , TW.object_center
                    ]
                ]
                []
            ]
        , HS.div
            [ HSA.css
                [ TW.box_border
                , TW.border_solid
                , TW.border_r
                , TW.border_l_0
                , TW.border_t
                , TW.border_b
                , TW.h_4over6
                ]
            ]
            []
        , HS.a
            [ HSA.href Types.ccgHome
            , HSA.target "_blank"
            ]
            [ HS.img
                [ HSA.src "/assets/images/ccg_logo.png"
                , HSA.css
                    [ TW.w_10
                    , TW.object_contain
                    , TW.object_center
                    ]
                ]
                []
            ]
        ]


error : Maybe String -> HS.Html Types.FrontendMsg
error m_str =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.w_1over3
            , TW.h_12
            , TW.flex
            , TW.flex_col
            , TW.justify_center
            , TW.items_center
            , TW.text_color TW.red_500
            ]
        ]
        [ HS.div
            []
            [ HS.text <| Maybe.withDefault "" m_str
            ]
        ]


title : HS.Html Types.FrontendMsg
title =
    HS.div
        [ HSA.css
            [ TW.box_border
            , TW.flex
            , TW.flex_col
            , TW.items_center
            , TW.mb_4
            ]
        ]
        [ HS.h1
            [ HSA.css
                [ TW.box_border
                , TW.w_fit
                , TW.h_fit
                , TW.flex
                , TW.flex_col
                , TW.justify_center
                , TW.items_center
                , TW.text_6xl
                , TW.mb_0
                ]
            ]
            [ HS.text "Trick Tac Toe"
            ]
        , HS.div
            [ HSA.css
                [ TW.text_sm
                ]
            ]
            [ HS.text "Elm Game Jam 6 Edition"
            ]
        , HS.div
            [ HSA.css
                [ TW.text_sm
                ]
            ]
            [ HS.text "Designed and engineered by Matt Virgin"
            ]
        , Types.helpLink "Copyright 2023 Crazy Cockatoo Games™" Types.ccgHome
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
            , TW.items_center
            ]
        ]
        [ HS.input
            [ HSA.css
                [ TW.box_border
                , TW.w_full
                , TW.h_10
                , TW.my_1
                ]
            , HSA.placeholder placeholder
            , HSA.value input
            , HSE.onInput handler
            ]
            []
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
