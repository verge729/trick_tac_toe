module Engine.Engine exposing 
    ( processTurnRegular
    , processTurnUltimate
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

type alias Claim a =
    { submitting_player : Player.Player
    , other_player : Player.Player
    , claim : Sector.Sector
    , coordinate : Coordinates.CoordinateSystem
    , turn : Int
    , board : a
    , seed : Random.Seed
    }

type alias ClaimResult a =
    { turn : Int
    , board : a   
    , event : Events.Event
    , next_player : Player.Player   
    , path_to_victory : Victory.PathToVictory 
    }

type alias ProcessContentResult a=
    { board : a
    , event : Events.Event  
    , seed : Random.Seed      
    }

{- ANCHOR process Ultimate board -}
processTurnUltimate : Claim Board.UltimateBoard -> ClaimResult Board.UltimateBoard
processTurnUltimate claim =
    let
        process_content =
            case claim.claim.content of
                SectorAttribute.Trick trick ->
                    case trick.trick_type of
                        Trick.Vanish ->
                            processContentUltimate claim 

                        Trick.WrongDestination ->
                            processContentUltimate claim

                _ ->
                    processContentUltimate 
                        { claim 
                            | board = updateBoardUltimate claim.board claim.coordinate claim.submitting_player 
                        }

        path_to_victory =
            checkVictoryUltimate process_content.board claim.submitting_player
    in
    ClaimResult 
        (advanceTurn claim.turn) 
        process_content.board 
        process_content.event
        claim.other_player
        path_to_victory
        
processContentUltimate : Claim Board.UltimateBoard -> ProcessContentResult Board.UltimateBoard
processContentUltimate claim =
    case claim.claim.content of
        SectorAttribute.Trick trick ->
            let
                (tricked_out, seed) = 
                    TrickHandlers.handleTrickUltimate 
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

updateBoardUltimate : Board.UltimateBoard -> Coordinates.Coordinates -> Player.Player -> Board.UltimateBoard       
updateBoardUltimate board coordinate player =
    UltimateBoard.updateBoard board coordinate (SectorAttribute.Claimed player) player

checkVictoryUltimate : Board.UltimateBoard -> Player.Player -> Victory.PathToVictory
checkVictoryUltimate board player =
    Victory.checkVictory board player

{- ANCHOR process Regular board -}

processTurnRegular : Claim Board.RegularBoard  -> ClaimResult Board.RegularBoard 
processTurnRegular claim =
    let
        proccess_content =
            case claim.claim.content of
                SectorAttribute.Trick trick ->
                    case trick.trick_type of
                        Trick.Vanish ->
                            processContentRegular claim 

                        Trick.WrongDestination ->
                            processContentRegular claim

                _ ->
                    processContentRegular 
                        { claim 
                            | board = updateBoardRegular claim.board claim.coordinate claim.submitting_player 
                        } 

        path_to_victory =
            checkVictoryRegular proccess_content.board claim.submitting_player
    in
    ClaimResult 
        (advanceTurn claim.turn) 
        proccess_content.board 
        proccess_content.event
        claim.other_player
        path_to_victory

updateBoardRegular : Board.RegularBoard -> Coordinates.Sector -> Player.Player -> Board.RegularBoard
updateBoardRegular board coordinate player =
    BaseBoard.updateBoard board coordinate (SectorAttribute.Claimed player)

processContentRegular : Claim Board.RegularBoard -> ProcessContentResult Board.RegularBoard
processContentRegular claim =
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

checkVictoryRegular : Board.RegularBoard -> Player.Player -> Victory.PathToVictory
checkVictoryRegular board player =
    Victory.checkVictory board player


advanceTurn : Int -> Int
advanceTurn turn =
    turn + 1
