//
// StagedChessClockTests.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import XCTest
@testable import FunctionalChessClock

final class SequncedChessClockTests: XCTestCase {
    func testThatUpdatingLessTimesThanMoveCountKeepsTheFirstSettings() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .switchTo(nextStage: FischerIncrementChessClock(totalTime: .seconds(10), incrementValue: .seconds(5)),
                      afterMove: 5)
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(11))
            .beginUpdates(time: .seconds(12))
            .endUpdates(time: .seconds(13))
            .beginUpdates(time: .seconds(14))
            .endUpdates(time: .seconds(15))
        
        XCTAssertEqual(result.timeValue, .seconds(97))
    }
    
    func testThatUpdatingMoveCountTimesSwitchesToSecondState() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .switchTo(nextStage: FischerIncrementChessClock(totalTime: .seconds(10), incrementValue: .seconds(5)),
                      afterMove: 5)
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(11))
            .beginUpdates(time: .seconds(12))
            .endUpdates(time: .seconds(13))
            .beginUpdates(time: .seconds(14))
            .endUpdates(time: .seconds(15))
            .beginUpdates(time: .seconds(16))
            .endUpdates(time: .seconds(17))
            .beginUpdates(time: .seconds(18))
            .endUpdates(time: .seconds(19))
        
        XCTAssertEqual(result.timeValue, .seconds(105)) // time value of the second state is added
    }
    
    func testThatUpdatingMoreTimesThanMoveCountOperatesWithTheSecondState() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .switchTo(nextStage: FischerIncrementChessClock(totalTime: .seconds(10), incrementValue: .seconds(5)),
                      afterMove: 5)
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(11))
            .beginUpdates(time: .seconds(12))
            .endUpdates(time: .seconds(13))
            .beginUpdates(time: .seconds(14))
            .endUpdates(time: .seconds(15))
            .beginUpdates(time: .seconds(16))
            .endUpdates(time: .seconds(17))
            .beginUpdates(time: .seconds(18))
            .endUpdates(time: .seconds(19))
            .beginUpdates(time: .seconds(20))
            .endUpdates(time: .seconds(21))

        XCTAssertEqual(result.timeValue, .seconds(109))
    }
}
