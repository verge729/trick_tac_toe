module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Backend.Model as BackendModel
import Frontend.Model as FrontendModel
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Types.Tricks.Trick as Trick


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
    | CatchRandomGeneratorSector (List Coordinates.Sector)
    | CatchRandomGeneratorTrick (List Trick.TrickType)


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend