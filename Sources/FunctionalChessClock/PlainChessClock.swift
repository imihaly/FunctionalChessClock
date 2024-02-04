//
//  PlainChessClockState.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

public struct PlainChessClock: ChessClock {
    
    enum State {
        case paused
        case updating(referenceTime: TimeValue, lastUpdateTime: TimeValue)
    }
        
    let totalTime: TimeValue
    let state: State
    
    private init(totalTime: TimeValue, state: State) {
        self.totalTime = totalTime
        self.state = state
    }
    
    public init(totalTime: TimeValue) {
        self.totalTime = totalTime
        self.state = .paused
    }
    
    // MARK: ChessClock interface
    
    public var timeValue: TimeValue {
        switch state {
        case .paused:
            return totalTime
        case .updating(referenceTime: let referenceTime, lastUpdateTime: let lastUpdateTime):
            return totalTime + referenceTime - lastUpdateTime
        }
    }
    
    public func increment(value: TimeValue) -> ChessClock {
        Self(totalTime: totalTime + value, state: state)
    }

    public func beginUpdates(time: TimeValue) -> ChessClock {
        return Self(totalTime: totalTime, state: .updating(referenceTime: time, lastUpdateTime: time))
    }
        
    public func update(time: TimeValue) -> ChessClock {
        update(time: time, commit: false)
    }
    
    public func endUpdates(time: TimeValue) -> ChessClock {
        update(time: time, commit: true)
    }
    
    private func update(time: TimeValue, commit: Bool) -> ChessClock {
        guard case let .updating(referenceTime: referenceTime, lastUpdateTime: _) = state else {
            return self
        }
        
        let ellapsed = time - referenceTime
        if ellapsed >= totalTime {
            return FinishedChessClock(leftoverTime: ellapsed - totalTime)
        }

        if commit {
            return Self(totalTime: totalTime - ellapsed, state: .paused)
        } else {
            return Self(totalTime: totalTime, state: .updating(referenceTime: referenceTime, lastUpdateTime: time))
        }
    }
}
