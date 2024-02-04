//
//  InactiveChessClockState.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

// Representing the state when the other side is active.
struct InactiveChessClock : ChessClock {
    
    var isActive: Bool { false }
    
    var isFinal: Bool { clockToActivate.isFinal }
    
    var clockToActivate: ChessClock

    var timeValue: TimeValue {
        clockToActivate.timeValue
    }

    func increment(value: TimeValue) -> ChessClock {
        Self(clockToActivate: clockToActivate.increment(value: value))
    }

    init(clockToActivate: ChessClock) {
        self.clockToActivate = clockToActivate
    }
    
    func deactivate(time: TimeValue) -> ChessClock {
        self
    }
    
    func activate(time: TimeValue) -> ChessClock {
        clockToActivate.beginUpdates(time: time)
    }
}
