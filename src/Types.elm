module Types exposing (..)

import Backend.Model as BackendModel
import Browser exposing (UrlRequest)
import Frontend.Model as FrontendModel
import Lamdera exposing (ClientId, SessionId)
import Random
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Types.Navigation as Navigation
import Types.Storage.Auth as StorageAuth
import Types.Storage.Game as StorageGame
import Types.Storage.Response as StorageResponse
import Types.Storage.User as StorageUser
import Url exposing (Url)
import Types.Board as Board


type alias FrontendModel =
    FrontendModel.FrontendModel


type alias BackendModel =
    BackendModel.BackendModel


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | NextCoordinateLowHover (Maybe Coordinates.Sector)
    | NextCoordinateMidHover (Maybe Coordinates.Sector)
    | ClaimSector Sector.Sector
    | CatchRandomGeneratorSeedFE Random.Seed
    | FillHandler String
    | FillKeyphrase String
    | FillGameName String
    | FillJoinCode String
    | SelectBoard Board.SelectBoard
    | Login
    | Register
    | GameViewAreaNavTo Navigation.GameArea
    | SelectGame StorageGame.GameId
    | SubmitGameCreation
    | SubmitJoinGame



type ToBackend
    = NoOpToBackend
    | AddUser StorageAuth.AuthReqs
    | LoginUser StorageAuth.AuthReqs
    | CreateGame StorageGame.GameCreationReqs
    | RequestGames StorageUser.User
    | JoinGame StorageGame.GameJoinReqs
    | UpdateGame StorageGame.Game


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | CatchRandomGeneratorSeedBE Random.Seed


type ToFrontend
    = NoOpToFrontend
    | RegistrationResponse StorageResponse.Registration
    | LoginResponse StorageResponse.Login
    | CreateGameRespnse StorageResponse.CreateGame
    | RequestGamesResponse StorageResponse.RequestGames
    | JoinGameResponse StorageResponse.JoinGame
    | UpdateGameResponse StorageResponse.UpdateGame
