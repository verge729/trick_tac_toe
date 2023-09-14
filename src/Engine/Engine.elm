module Engine.Engine exposing 
    ( processTurn
    , Claim
    , ClaimResult
    )

import Types.Base.Sector as Sector
import Types.Board as Board
import Types.Base.Board as BaseBoard
import Types.Coordinates as Coordinates
import Types.Player as Player
import Types.Events as Events
import Types.Tricks.TrickHandlers as TrickHandlers
import Types.Victory as Victory
import Types.SectorAttribute as SectorAttribute
import Types.Tricks.Trick as Trick
import Random
import Types.Ultimate.Board as UltimateBoard
import Types.Storage.User as User

type alias Claim =
    { submitting_player : Player.Player
    , other_player : Player.Player
    , claim : Sector.Sector
    , coordinate : Coordinates.CoordinateSystem
    , turn : Int
    , board : Board.Board
    , seed : Random.Seed
    }

type alias ClaimResult =
    { turn : Int
    , board : Board.Board  
    , event : Events.Event
    , next_player : Player.Player   
    , path_to_victory : Victory.PathToVictory 
    }

type alias ProcessContentResult =
    { board : Board.Board
    , event : Events.Event  
    , seed : Random.Seed      
    }

processTurn : Claim -> ClaimResult
processTurn claim =
    let
        process_content =
            case claim.claim.content of
                SectorAttribute.Trick trick ->
                    case trick.trick_type of
                        Trick.Vanish ->
                            processContent claim 

                        Trick.WrongDestination ->
                            processContent claim

                _ ->
                    processContent 
                        { claim 
                            | board = updateBoard claim.board claim.coordinate claim.submitting_player 
                        }

        path_to_victory =
            Victory.checkVictory process_content.board claim.submitting_player
    in
    ClaimResult 
        (advanceTurn claim.turn) 
        process_content.board 
        process_content.event
        claim.other_player
        path_to_victory

processContent : Claim -> ProcessContentResult
processContent claim =
    case claim.claim.content of
        SectorAttribute.Trick trick ->
            let
                (tricked_out, seed) = 
                    TrickHandlers.handleTrick
                        ( TrickHandlers.TrickHandler 
                            trick.trick_type 
                            claim.submitting_player 
                            claim.turn 
                            claim.coordinate
                            claim.board
                            claim.seed
                        )
            in
            ProcessContentResult 
                tricked_out 
                ( Events.Event 
                    claim.turn 
                    (Events.Trick trick) 
                    claim.submitting_player 
                    claim.coordinate
                )
                seed


        SectorAttribute.Clear ->
            ProcessContentResult 
                claim.board 
                ( Events.Event 
                    claim.turn 
                    Events.Turn 
                    claim.submitting_player 
                    claim.coordinate
                )
                claim.seed

updateBoard : Board.Board -> Coordinates.CoordinateSystem -> Player.Player -> Board.Board
updateBoard board coordinates player =
    case (board, coordinates) of
        (Board.Regular regular, Coordinates.Regular sector) ->
            Board.Regular <| BaseBoard.updateBoard regular sector (SectorAttribute.Claimed player)

        (Board.Ultimate ultimate, Coordinates.Ultimate coordinate) ->
            Board.Ultimate <| UltimateBoard.updateBoard ultimate coordinate (SectorAttribute.Claimed player) player
            
        _ ->
            board

advanceTurn : Int -> Int
advanceTurn turn =
    turn + 1
