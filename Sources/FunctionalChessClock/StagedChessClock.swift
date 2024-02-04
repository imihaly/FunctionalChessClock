//
//  SequencedChessClockState.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

struct StagedChessClock : ChessClock {
    var timeValue: TimeValue {
        currentClock.timeValue
    }
    let moveIndex = 0
    let movesLeft: Int
    let currentClock: ChessClock
    let nextClock: ChessClock
    
    func beginUpdates(time: TimeValue) -> ChessClock {
        Self(movesLeft: movesLeft, currentClock: currentClock.beginUpdates(time: time), nextClock: nextClock)
    }
    
    func update(time: TimeValue) -> ChessClock {
        Self(movesLeft: movesLeft, currentClock: currentClock.update(time: time), nextClock: nextClock)
    }
    
    func endUpdates(time: TimeValue) -> ChessClock {
        let newCurrentClock = currentClock.endUpdates(time: time)
        if newCurrentClock.isFinal {
            return newCurrentClock
        }

        let newMovesLeft = movesLeft - 1
        if newMovesLeft > 0 {
            return Self(movesLeft: newMovesLeft, currentClock: newCurrentClock, nextClock: nextClock)
        } else {
            return nextClock.increment(value: newCurrentClock.timeValue)
        }
    }
}

public extension ChessClock {
    func switchTo(nextStage: ChessClock, afterMove moveCount: Int) -> ChessClock {
        StagedChessClock(movesLeft: moveCount,
                                 currentClock: self,
                                 nextClock: nextStage)
    }
}


