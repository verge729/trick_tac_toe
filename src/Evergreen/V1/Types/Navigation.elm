module Evergreen.V1.Types.Navigation exposing (..)


type DataPanel
    = Menu
    | GameDetails


type GameArea
    = Game
    | GameListActive
    | GameListWaiting
    | GameListFinished
    | CreateGame
    | Help
    | NotIdentified
    | JoinGame


type FullView
    = Authenticate
    | Authenticated
    | WhatIsThis
