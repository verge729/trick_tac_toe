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

        Types.CatchRandomGeneratorSeed seed ->
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
                            Engine.processTurnRegular
                                (Engine.Claim
                                    model.current_player
                                    other_player
                                    sector
                                    sector.coordinate
                                    model.turn
                                    board
                                    model.seed
                                )
                    in
                    ( updateModelwithProcessedClaimRegular model processed_claim
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
                            Engine.processTurnUltimate
                                (Engine.Claim
                                    model.current_player
                                    other_player
                                    sector
                                    coordinates
                                    model.turn
                                    board
                                    model.seed
                                )
                    in
                    ( { model
                        | current_coordinate = Just { coordinates | mid = next_low }
                      }
                        |> updateModelwithProcessedClaimUltimate processed_claim
                    , Cmd.none
                    )


updateModelwithProcessedClaimRegular : Types.FrontendModel -> Engine.ClaimResult Board.RegularBoard Coordinates.Sector -> Types.FrontendModel
updateModelwithProcessedClaimRegular model claim_result =
    { model
        | turn = claim_result.turn
        , board = Board.Regular claim_result.board
        , current_player = claim_result.next_player
        , path_to_victory = claim_result.path_to_victory
        , list_events_regular = claim_result.event :: model.list_events_regular
    }


updateModelwithProcessedClaimUltimate : Engine.ClaimResult Board.UltimateBoard Coordinates.Coordinates -> Types.FrontendModel -> Types.FrontendModel
updateModelwithProcessedClaimUltimate claim_result model =
    { model
        | turn = claim_result.turn
        , board = Board.Ultimate claim_result.board
        , current_player = claim_result.next_player
        , path_to_victory = claim_result.path_to_victory
        , list_events_ultimate = claim_result.event :: model.list_events_ultimate
    }


updatePlayerAndTurn : UpdateTurn -> Types.FrontendModel -> Types.FrontendModel
updatePlayerAndTurn update_turn model =
    let
        next_player =
            if update_turn.current_player == update_turn.player_one then
                update_turn.player_two

            else
                update_turn.player_one
    in
    { model
        | turn = update_turn.current_turn + 1
        , current_player = next_player
    }


updateUltimateBoard : Coordinates.Coordinates -> Player.Player -> Board.UltimateBoard -> Board.UltimateBoard
updateUltimateBoard coordinates current_player board =
    let
        int_sector =
            Coordinates.toIntSector coordinates.mid
    in
    case Array.get int_sector board of
        Just board_low ->
            let
                ( updated_board, claimed_victory ) =
                    updateBoard coordinates.low current_player board_low.board

                updated_ultimate_sector =
                    case board_low.state of
                        SectorAttribute.Free ->
                            { board_low | board = updated_board, state = Victory.toStatePathToVictory claimed_victory }

                        SectorAttribute.Claimed _ ->
                            { board_low | board = updated_board }

                        SectorAttribute.Blocked ->
                            board_low

                finalized_board =
                    Array.set int_sector updated_ultimate_sector board
                        |> Board.checkAndUpdateForBlock
            in
            finalized_board

        Nothing ->
            board


updateBoard : Coordinates.Sector -> Player.Player -> Board.RegularBoard -> ( Board.RegularBoard, Victory.PathToVictory )
updateBoard coordinate current_player board =
    -- sector
    -- current player in model
    -- board in model
    -- update sector in board
    -- advance/swap current player
    let
        int_sector =
            Coordinates.toIntSector coordinate

        m_target_sector =
            Array.get int_sector board
    in
    case m_target_sector of
        Just target_sector ->
            let
                updated_target_sector =
                    { target_sector | state = SectorAttribute.Claimed current_player }

                updated_board =
                    Array.set int_sector updated_target_sector board

                claimed_victory =
                    Victory.checkVictory updated_board current_player
            in
            ( updated_board, claimed_victory )

        Nothing ->
            let
                _ =
                    Debug.log "updateBoard : Nothing branch" 0
            in
            ( board, Victory.Unacheived )
