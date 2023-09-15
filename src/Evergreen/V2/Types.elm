module Evergreen.V2.Types exposing (..)

import Browser
import Evergreen.V2.Backend.Model
import Evergreen.V2.Frontend.Model
import Evergreen.V2.Types.Base.Sector
import Evergreen.V2.Types.Board
import Evergreen.V2.Types.Coordinates
import Evergreen.V2.Types.Navigation
import Evergreen.V2.Types.Storage.Auth
import Evergreen.V2.Types.Storage.Game
import Evergreen.V2.Types.Storage.Response
import Evergreen.V2.Types.Storage.User
import Lamdera
import Random
import Url


type alias FrontendModel =
    Evergreen.V2.Frontend.Model.FrontendModel


type alias BackendModel =
    Evergreen.V2.Backend.Model.BackendModel


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | NextCoordinateLowHover (Maybe Evergreen.V2.Types.Coordinates.Sector)
    | NextCoordinateMidHover (Maybe Evergreen.V2.Types.Coordinates.Sector)
    | ClaimSector Evergreen.V2.Types.Base.Sector.Sector
    | CatchRandomGeneratorSeedFE Random.Seed
    | FillHandler String
    | FillKeyphrase String
    | FillGameName String
    | FillJoinCode String
    | SelectBoard Evergreen.V2.Types.Board.SelectBoard
    | Login
    | Register
    | GameViewAreaNavTo Evergreen.V2.Types.Navigation.GameArea
    | DataPanelNavTo Evergreen.V2.Types.Navigation.DataPanel
    | FullViewNavTo Evergreen.V2.Types.Navigation.FullView
    | SelectGame Evergreen.V2.Types.Storage.Game.GameId
    | SubmitGameCreation
    | SubmitJoinGame


type ToBackend
    = NoOpToBackend
    | AddUser Evergreen.V2.Types.Storage.Auth.AuthReqs
    | LoginUser Evergreen.V2.Types.Storage.Auth.AuthReqs
    | CreateGame Evergreen.V2.Types.Storage.Game.GameCreationReqs
    | RequestGames Evergreen.V2.Types.Storage.User.User
    | JoinGame Evergreen.V2.Types.Storage.Game.GameJoinReqs
    | UpdateGame Evergreen.V2.Types.Storage.Game.Game


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | CatchRandomGeneratorSeedBE Random.Seed


type ToFrontend
    = NoOpToFrontend
    | RegistrationResponse Evergreen.V2.Types.Storage.Response.Registration
    | LoginResponse Evergreen.V2.Types.Storage.Response.Login
    | CreateGameRespnse Evergreen.V2.Types.Storage.Response.CreateGame
    | RequestGamesResponse Evergreen.V2.Types.Storage.Response.RequestGames
    | JoinGameResponse Evergreen.V2.Types.Storage.Response.JoinGame
    | UpdateGameResponse Evergreen.V2.Types.Storage.Response.UpdateGame
