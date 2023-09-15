module Types.Navigation exposing (..)

type GameArea
    = Game
    | GameListActive
    | GameListWaiting
    | GameListFinished
    | CreateGame
    | Help
    | NotIdentified
    | JoinGame
    

type DataPanel
    = Menu
    | GameDetails

type FullView
    = Authenticate
    | Authenticated
    | WhatIsThis

type HelpSection
    = Home
    