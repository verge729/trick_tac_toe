module Types.Base.Board exposing (..)

import Array
import Types.Base.Sector as Sector
import Types.Coordinates as Coordinates
import Types.SectorAttribute as SectorAttribute
import Types.Tricks.Trick as Trick
import Types.Player as Player
import Random
import Types.Tricks.Trick as Trick


type alias RegularBoard =
    Array.Array Sector.Sector


boardRegular : (RegularBoard, Int)
boardRegular =
    let
        board_size =
            9
    in
    ( Array.initialize board_size (\i -> Sector.defaultSector <| Coordinates.toSectorFromInt i)
    , board_size
    )

updateBoard : RegularBoard -> Coordinates.Sector -> SectorAttribute.State -> RegularBoard
updateBoard board coordinate state =
    let
        int_sector =
            Coordinates.toIntSector coordinate

        m_target_sector =
            Array.get int_sector board
    in 
    case m_target_sector of
        Just target_sector ->
            Array.set 
                int_sector 
                { target_sector | state = state } 
                board

        Nothing ->
            board

addTricks : RegularBoard -> Random.Seed -> (RegularBoard, Random.Seed)
addTricks board seed =
    let
        (sectors, new_seed) =
            Random.step Coordinates.randomGeneratorRegular seed
    in
    Array.foldl (\sector (array, next_seed) ->
        let
            (trick, new_next_seed) =
                if List.member sector.coordinate sectors then
                    let
                        (tr, n_seed) =
                            Random.step Trick.randomGeneratorTrick next_seed
                    in
                        (SectorAttribute.Trick <| Trick.getTrickFromType tr, n_seed)
                else
                    (SectorAttribute.Clear, next_seed)
        in 
        (Array.push {sector | content = trick} array, new_next_seed)
    ) (Array.empty, new_seed) board