//
//  DelayingChessClockState.swift
//  ChessClock
//
//  Created by Imre Mihaly on 24/01/2024.
//

import Foundation

// something like this for delayed state
struct DelayingChessClockState: ChessClockState {
    var timeValue: Double {
        nextState.timeValue
    }
    var delayValue: Double

    var delayState: ChessClockState
    var nextState: ChessClockState
 
    func update(date: Date) -> ChessClockState {
        let nextDelayState = delayState.update(date: date)
        if nextDelayState.isFinal {
            
            // here we should calculate with overticking in delayed state
            return nextState.activate(date: date)
        } else {
            return Self(delayValue: delayValue, delayState: nextDelayState, nextState: nextState)
        }
    }
    
}
