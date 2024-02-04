//
// BronsteinIncrementChessClock.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import Foundation

public struct BronsteinIncrementChessClock: ChessClock {
    enum State {
        case paused
        case updating(delayClock: ChessClock)
    }
    
    let incrementValue: TimeValue
    let incrementedClock: ChessClock
    let state: State
    public var timeValue: TimeValue { incrementedClock.timeValue }
    
    public init(totalTime: TimeValue, incrementValue: TimeValue) {
        self.init(incrementValue: incrementValue, incrementedClock: PlainChessClock(totalTime: totalTime), state: .paused)
    }
    
    private init(incrementValue: TimeValue, incrementedClock: ChessClock, state: State) {
        self.incrementValue = incrementValue
        self.incrementedClock = incrementedClock
        self.state = state
    }
    
    public func increment(value: TimeValue) -> ChessClock {
        Self(incrementValue: incrementValue, incrementedClock: incrementedClock.increment(value: value), state: state)
    }
    
    public func beginUpdates(time: TimeValue) -> ChessClock {
        Self(incrementValue: incrementValue,
             incrementedClock: incrementedClock.beginUpdates(time: time),
             state: .updating(delayClock: PlainChessClock(totalTime: incrementValue).beginUpdates(time: time)))
    }
    
    public func update(time: TimeValue) -> ChessClock {
        guard case .updating(let delayClock) = state else {
            assert(false)
        }

        let newIncrementedClock = incrementedClock.update(time: time)
        if newIncrementedClock.isFinal {
            return newIncrementedClock
        }
        return Self(incrementValue: incrementValue, incrementedClock: newIncrementedClock, state: .updating(delayClock: delayClock.update(time: time)))
    }
    
    public func endUpdates(time: TimeValue) -> ChessClock {
        guard case .updating(let delayClock) = state else {
            assert(false)
        }

        let newIncrementedClock = incrementedClock.endUpdates(time: time)
        if newIncrementedClock.isFinal {
            return newIncrementedClock
        }
        
        let increment = incrementValue - delayClock.endUpdates(time: time).timeValue
        
        return Self(incrementValue: incrementValue, incrementedClock: newIncrementedClock.increment(value: increment), state: .paused)
    }
}
