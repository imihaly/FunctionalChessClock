//
//  FischerIncrementChessClock.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

public struct FischerIncrementChessClock: ChessClock {
    
    enum State {
        case paused
        case updating
    }
        
    let state: State
    let incrementValue: TimeValue
    let incrementedClock: ChessClock
    public var timeValue: TimeValue { incrementedClock.timeValue }
    
    public init(totalTime: TimeValue, incrementValue: TimeValue) {
        self.incrementValue = incrementValue
        self.incrementedClock = PlainChessClock(totalTime: totalTime)
        self.state = .paused
    }
    
    private init(incrementValue: TimeValue, incrementedClock: ChessClock, state: State = .paused) {
        self.incrementValue = incrementValue
        self.incrementedClock = incrementedClock
        self.state = state
    }
    
    public func increment(value: TimeValue) -> ChessClock {
        Self(incrementValue: incrementValue, incrementedClock: incrementedClock.increment(value: value))
    }

    public func beginUpdates(time: TimeValue) -> ChessClock {
        assert(state == .paused)
        return Self(incrementValue: incrementValue, incrementedClock: incrementedClock.beginUpdates(time: time), state: .updating)
    }

    public func update(time: TimeValue) -> ChessClock {
        assert(state == .updating)
        let newIncrementedClock = incrementedClock.update(time: time)
        if newIncrementedClock.isFinal {
            return newIncrementedClock
        }
        return Self(incrementValue: incrementValue, incrementedClock: newIncrementedClock, state: state)
    }
    
    public func endUpdates(time: TimeValue) -> ChessClock {
        assert(state == .updating)
        let newIncrementedClock = incrementedClock.endUpdates(time: time)
        if newIncrementedClock.isFinal {
            return newIncrementedClock
        }
        return Self(incrementValue: incrementValue, incrementedClock: newIncrementedClock.increment(value: incrementValue), state: .paused)
    }
}
