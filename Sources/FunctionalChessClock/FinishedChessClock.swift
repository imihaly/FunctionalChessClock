//
//  FinishedChessClockState.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

struct FinishedChessClock: ChessClock {
    var isFinal: Bool { true }
    var timeValue: TimeValue { .seconds(0) }
    var leftoverTime: TimeValue
}
