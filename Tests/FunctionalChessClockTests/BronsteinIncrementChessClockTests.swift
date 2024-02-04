//
// BronsteinIncrementChessClockTests.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import XCTest
@testable import FunctionalChessClock

final class BronsteinIncrementChessClockTests: XCTestCase {

    func testThatUpdatingForZeroSecondsWillNotChangeTimeValue() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(100), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(10))
        
        XCTAssertEqual(result.timeValue, .seconds(100))
    }
    
    func testThatUpdatingForLessThanIncrementWillNotChangeTimeValue() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(100), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(12))
        
        XCTAssertEqual(result.timeValue, .seconds(100))
    }

    func testThatUpdatingForMoreThanIncrementWillAddIncrement() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(100), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(20))
        
        XCTAssertEqual(result.timeValue, .seconds(95))
    }

    func testThatUpdatingForMoreSecondsThenTimeValueWillTerminate() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(100), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .update(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(10))
        XCTAssertTrue(result.isFinal)
    }

    func testThatUpdatingForMoreSecondsThenTimeValueWillTerminateEvenIfIncrementWouldCompensate() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(1), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .update(time: .seconds(12))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(1))
        XCTAssertTrue(result.isFinal)
    }

    func testThatCommittingUpdateAfterMoreSecondsThenTimeValueWillTerminate() throws {
        let result = BronsteinIncrementChessClock(totalTime: .seconds(100), incrementValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(10))
        XCTAssertTrue(result.isFinal)
    }

}
