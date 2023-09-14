module Types.Navigation exposing (..)

type GameArea
    = Game
    | GameList
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