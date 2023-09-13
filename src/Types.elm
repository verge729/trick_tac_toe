module Types exposing (..)

import Browser exposing (UrlRequest)
import Url exposing (Url)
import Backend.Model as BackendModel
import Frontend.Model as FrontendModel
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Lamdera exposing (ClientId, SessionId)
import Types.Tricks.Trick as Trick
import Random
import Types.Storage.Auth as StorageAuth
import Types.Storage.Response as StorageResponse


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


type ToBackend
    = NoOpToBackend
    | AddUser StorageAuth.AuthReqs
    | LoginUser StorageAuth.AuthReqs


type BackendMsg
    = NoOpBackendMsg
    | ClientConnected SessionId ClientId
    | ClientDisconnected SessionId ClientId
    | CatchRandomGeneratorSeedBE Random.Seed


type ToFrontend
    = NoOpToFrontend
    | RegistrationResponse StorageResponse.Registration
    | LoginResponse StorageResponse.Login