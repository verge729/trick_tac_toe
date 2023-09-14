module Frontend.UI.GameList exposing (..)

import Html.Styled as HS
import Html.Styled.Attributes as HSA
import Html.Styled.Events as HSE
import Tailwind.Theme as TW
import Tailwind.Utilities as TW
import Types
import Types.Storage.Game as StorageGame

root : List StorageGame.Game -> HS.Html Types.FrontendMsg
root list_games =
    HS.div
        []
        ( List.map gameCard list_games)

gameCard : StorageGame.Game -> HS.Html Types.FrontendMsg
gameCard game =
    HS.div
        [ HSA.css
            []
        , HSE.onClick <| Types.SelectGame game.id            
        ]
        [ HS.text game.game_name            
        ]