//
//  PlainChessClockTests.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import XCTest
@testable import FunctionalChessClock

final class PlainChessClockTests: XCTestCase {
    
    func testThatUpdatingForZeroSecondsWillNotChangeTimeValue() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(10))
        
        XCTAssertEqual(result.timeValue, .seconds(100))
    }

    func testThatUpdatingForSomeSecondsWillChangeTimeValueAppropriately() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(20))
        
        XCTAssertEqual(result.timeValue, .seconds(90))
    }

    func testThatUpdatingForMoreSecondsThenTimeValueWillTerminate() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .beginUpdates(time: .seconds(10))
            .update(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(10))
        XCTAssertTrue(result.isFinal)
    }

    func testThatCommittingUpdateAfterMoreSecondsThenTimeValueWillTerminate() throws {
        let result = PlainChessClock(totalTime: .seconds(100))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(10))
        XCTAssertTrue(result.isFinal)
    }
}
