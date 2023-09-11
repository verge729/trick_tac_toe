module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Url exposing (Url)
import Backend.Model as BackendModel
import Frontend.Model as FrontendModel


type alias FrontendModel =
    FrontendModel.FrontendModel


type alias BackendModel =
    BackendModel.BackendModel

type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg


type ToBackend
    = NoOpToBackend


type BackendMsg
    = NoOpBackendMsg


type ToFrontend
    = NoOpToFrontend