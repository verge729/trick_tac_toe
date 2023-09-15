module Evergreen.V1.Types exposing (..)

import Browser
import Evergreen.V1.Backend.Model
import Evergreen.V1.Frontend.Model
import Evergreen.V1.Types.Base.Sector
import Evergreen.V1.Types.Board
import Evergreen.V1.Types.Coordinates
import Evergreen.V1.Types.Navigation
import Evergreen.V1.Types.Storage.Auth
import Evergreen.V1.Types.Storage.Game
import Evergreen.V1.Types.Storage.Response
import Evergreen.V1.Types.Storage.User
import Lamdera
import Random
import Url


type alias FrontendModel =
    Evergreen.V1.Frontend.Model.FrontendModel


type alias BackendModel =
    Evergreen.V1.Backend.Model.BackendModel


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg
    | NextCoordinateLowHover (Maybe Evergreen.V1.Types.Coordinates.Sector)
    | NextCoordinateMidHover (Maybe Evergreen.V1.Types.Coordinates.Sector)
    | ClaimSector Evergreen.V1.Types.Base.Sector.Sector
    | CatchRandomGeneratorSeedFE Random.Seed
    | FillHandler String
    | FillKeyphrase String
    | FillGameName String
    | FillJoinCode String
    | SelectBoard Evergreen.V1.Types.Board.SelectBoard
    | Login
    | Register
    | GameViewAreaNavTo Evergreen.V1.Types.Navigation.GameArea
    | DataPanelNavTo Evergreen.V1.Types.Navigation.DataPanel
    | FullViewNavTo Evergreen.V1.Types.Navigation.FullView
    | SelectGame Evergreen.V1.Types.Storage.Game.GameId
    | SubmitGameCreation
    | SubmitJoinGame


type ToBackend
    = NoOpToBackend
    | AddUser Evergreen.V1.Types.Storage.Auth.AuthReqs
    | LoginUser Evergreen.V1.Types.Storage.Auth.AuthReqs
    | CreateGame Evergreen.V1.Types.Storage.Game.GameCreationReqs
    | RequestGames Evergreen.V1.Types.Storage.User.User
    | JoinGame Evergreen.V1.Types.Storage.Game.GameJoinReqs
    | UpdateGame Evergreen.V1.Types.Storage.Game.Game


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected Lamdera.SessionId Lamdera.ClientId
    | ClientDisconnected Lamdera.SessionId Lamdera.ClientId
    | CatchRandomGeneratorSeedBE Random.Seed


type ToFrontend
    = NoOpToFrontend
    | RegistrationResponse Evergreen.V1.Types.Storage.Response.Registration
    | LoginResponse Evergreen.V1.Types.Storage.Response.Login
    | CreateGameRespnse Evergreen.V1.Types.Storage.Response.CreateGame
    | RequestGamesResponse Evergreen.V1.Types.Storage.Response.RequestGames
    | JoinGameResponse Evergreen.V1.Types.Storage.Response.JoinGame
    | UpdateGameResponse Evergreen.V1.Types.Storage.Response.UpdateGame
