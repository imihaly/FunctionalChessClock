//
//  USDelayChessClock.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

public struct USDelayChessClock: ChessClock {
    enum State {
        case paused
        case delaying(delayClock: ChessClock)
        case updating
    }
    
    public var timeValue: TimeValue { delayedClock.timeValue }
    let delayValue: TimeValue
    
    let delayedClock: ChessClock
    let state: State
    
    private init(delayValue: TimeValue, delayedClock: ChessClock, state: State) {
        self.delayValue = delayValue
        self.delayedClock = delayedClock
        self.state = state
    }

    public init(totalTime: TimeValue, delayValue: TimeValue) {
        self.init(delayValue: delayValue,
                  delayedClock: PlainChessClock(totalTime: totalTime),
                  state: .paused
        )
    }
    
    public func increment(value: TimeValue) -> ChessClock {
        Self(delayValue: delayValue,
             delayedClock: delayedClock.increment(value: value),
             state: state)
    }
    
    public func beginUpdates(time: TimeValue) -> ChessClock {
        guard case .paused = state else {
            assert(false)
        }
        return Self(delayValue: delayValue,
                    delayedClock: delayedClock,
                    state: .delaying(delayClock: PlainChessClock(totalTime: delayValue).beginUpdates(time: time)))
    }
    
    public func update(time: TimeValue) -> ChessClock {
        switch state {
        case .paused:
            assert(false)
            
        case .delaying(delayClock: let delayClock):
            let newDelayClock = delayClock.update(time: time)
            let newDelayedClock = newDelayClock.isFinal ? delayedClock.beginUpdates(time: time - newDelayClock.leftoverTime).update(time: time) : delayedClock
            
            if newDelayedClock.isFinal { return newDelayedClock }
            return Self(delayValue: delayValue,
                        delayedClock: newDelayedClock,
                        state: newDelayClock.isFinal ? .updating : .delaying(delayClock: newDelayClock))
            
        case .updating:
            let newDelayedClock = delayedClock.update(time: time)
            if newDelayedClock.isFinal { return newDelayedClock }
            return Self(delayValue: delayValue,
                        delayedClock: newDelayedClock,
                        state: state)
        }
    }
    
    public func endUpdates(time: TimeValue) -> ChessClock {
        switch state {
        case .paused:
            assert(false)
            
        case .delaying(delayClock: let delayClock):
            let newDelayClock = delayClock.endUpdates(time: time)
            let newDelayedClock = newDelayClock.isFinal ? delayedClock.beginUpdates(time: time - newDelayClock.leftoverTime).endUpdates(time: time) : delayedClock
            if newDelayedClock.isFinal { return newDelayedClock }
            return Self(delayValue: delayValue,
                        delayedClock: newDelayedClock,
                        state: .paused
            )
            
        case .updating:
            let newDelayedClock = delayedClock.endUpdates(time: time)
            if newDelayedClock.isFinal { return newDelayedClock }
            return Self(delayValue: delayValue,
                        delayedClock: newDelayedClock,
                        state: .paused)
        }
    }
}
