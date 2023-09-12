module Engine.Engine exposing (processTurn, Claim, ClaimResult)

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

type alias Claim =
    { submitting_player : Player.Player
    , other_player : Player.Player
    , claim : Sector.Sector
    , coordinate : Coordinates.Sector
    , turn : Int
    , board : Board.RegularBoard
    , seed : Random.Seed
    }

type alias ClaimResult =
    { turn : Int
    , board : Board.RegularBoard   
    , event : Events.Event 
    , next_player : Player.Player   
    , path_to_victory : Victory.PathToVictory 
    }

type alias ProcessContentResult =
    { board : Board.RegularBoard
    , event : Events.Event  
    , seed : Random.Seed      
    }


processTurn : Claim -> ClaimResult
processTurn claim =
    let
        proccess_content =
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
            checkVictory proccess_content.board claim.submitting_player
    in
    ClaimResult 
        (advanceTurn claim.turn) 
        proccess_content.board 
        proccess_content.event
        claim.other_player
        path_to_victory

updateBoard : Board.RegularBoard -> Coordinates.Sector -> Player.Player -> Board.RegularBoard
updateBoard board coordinate player =
    BaseBoard.updateBoard board coordinate (SectorAttribute.Claimed player)

processContent : Claim -> ProcessContentResult
processContent claim =
    case claim.claim.content of
        SectorAttribute.Trick trick ->
            let
                (tricked_out, seed) = 
                    TrickHandlers.handleTrickRegular 
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

checkVictory : Board.RegularBoard -> Player.Player -> Victory.PathToVictory
checkVictory board player =
    Victory.checkVictory board player

advanceTurn : Int -> Int
advanceTurn turn =
    turn + 1
