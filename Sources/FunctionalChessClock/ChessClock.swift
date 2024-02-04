//
//  ChessClockState.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

enum UpdateState {
    case initial
    case begun(at: TimeValue)
    case committed(at: TimeValue)
}

public protocol ChessClock {
    var timeValue: TimeValue { get }
    var leftoverTime: TimeValue { get }
    var isFinal: Bool { get }
    var isActive: Bool { get }
    
    func increment(value: TimeValue) -> ChessClock
    func beginUpdates(time: TimeValue) -> ChessClock
    func update(time: TimeValue) -> ChessClock
    func endUpdates(time: TimeValue) -> ChessClock
    
    func activate(time: TimeValue) -> ChessClock
    func deactivate(time: TimeValue) -> ChessClock
}

public extension ChessClock {
    
    var isFinal: Bool { false }
    var isActive: Bool { true }
    var leftoverTime: TimeValue { .seconds(0) }
    
    func increment(value: TimeValue) -> ChessClock { self }
    func activate(time: TimeValue) -> ChessClock { self }
    func deactivate(time: TimeValue) -> ChessClock {
        InactiveChessClock(clockToActivate: self.endUpdates(time: time))
    }
    func beginUpdates(time: TimeValue) -> ChessClock { self }
    func update(time: TimeValue) -> ChessClock { self }
    func endUpdates(time: TimeValue) -> ChessClock { self }
}
