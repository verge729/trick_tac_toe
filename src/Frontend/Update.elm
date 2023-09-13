module Frontend.Update exposing (..)

import Array
import Browser
import Browser.Navigation as Nav
import Engine.Engine as Engine
import Types
import Types.Base.Board as BaseBoard
import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.SectorAttribute as SectorAttribute
import Types.Ultimate.Board as UltimateBoard
import Types.Victory as Victory
import Url


type alias UpdateTurn =
    { player_one : Player.Player
    , player_two : Player.Player
    , current_player : Player.Player
    , current_turn : Int
    }


update : Types.FrontendMsg -> Types.FrontendModel -> ( Types.FrontendModel, Cmd Types.FrontendMsg )
update msg model =
    case msg of
        Types.UrlClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        Types.UrlChanged url ->
            ( model, Cmd.none )

        Types.NoOpFrontendMsg ->
            ( model, Cmd.none )

        Types.CatchRandomGeneratorSeedFE seed ->
            let
                ( board, max_turns ) =
                    -- BaseBoard.boardRegular
                    UltimateBoard.boardUltimate

                ( tricked_board, new_seed ) =
                    -- BaseBoard.addTricks board seed
                    UltimateBoard.addTricks board seed
            in
            ( { model
                | seed = new_seed
                , board = Board.Ultimate tricked_board
              }
            , Cmd.none
            )

        Types.NextCoordinateLowHover m_sector ->
            ( { model | next_coordinate_low = m_sector }
            , Cmd.none
            )

        Types.NextCoordinateMidHover m_sector ->
            ( { model | next_coordinate_mid = m_sector }
            , Cmd.none
            )

        Types.ClaimSector sector ->
            let
                other_player =
                    if model.current_player == model.player_one then
                        model.player_two

                    else
                        model.player_one
            in
            case model.board of
                Board.NotSelected ->
                    ( model
                    , Cmd.none
                    )

                Board.Regular board ->
                    let
                        processed_claim =
                            Engine.processTurn
                                (Engine.Claim
                                    model.current_player
                                    other_player
                                    sector
                                    (Coordinates.Regular sector.coordinate)
                                    model.turn
                                    model.board
                                    model.seed
                                )
                    in
                    ( updateModelwithProcessedClaim processed_claim model
                    , Cmd.none
                    )

                Board.Ultimate board ->
                    let
                        next_low =
                            Maybe.withDefault Coordinates.Zero model.next_coordinate_low

                        next_mid =
                            Maybe.withDefault Coordinates.Zero model.next_coordinate_mid

                        coordinates =
                            { low = next_low, mid = next_mid }

                        processed_claim =
                            Engine.processTurn
                                (Engine.Claim
                                    model.current_player
                                    other_player
                                    sector
                                    (Coordinates.Ultimate coordinates)
                                    model.turn
                                    model.board
                                    model.seed
                                )
                    in
                    ( { model
                        | current_coordinate = Just { coordinates | mid = next_low }
                      }
                        |> updateModelwithProcessedClaim processed_claim
                    , Cmd.none
                    )



updateModelwithProcessedClaim : Engine.ClaimResult -> Types.FrontendModel -> Types.FrontendModel
updateModelwithProcessedClaim claim_result model =
    { model
        | turn = claim_result.turn
        , board = claim_result.board
        , current_player = claim_result.next_player
        , path_to_victory = claim_result.path_to_victory
        , list_events = claim_result.event :: model.list_events
    }
