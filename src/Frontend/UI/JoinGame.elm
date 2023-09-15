module Frontend.UI.JoinGame exposing (..)

import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Button as Button


type alias InputData =
    { target : Maybe String
    , handler : String -> Types.FrontendMsg
    , placeholder : String
    }


root : Types.FrontendModel -> HS.Html Types.FrontendMsg
root model =
    let
        input_data =
            { target = model.m_join_code
            , handler = Types.FillJoinCode
            , placeholder = "Enter game code"
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
            , TW.space_y_2
            ]
        ]
        [ elementInputText input_data
        , Button.button "Join Game" Types.SubmitJoinGame Button.Regular Button.Unselected
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


elementInputText : InputData -> HS.Html Types.FrontendMsg
elementInputText { target, handler, placeholder } =
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
            , TW.w_7over12
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
        ]
