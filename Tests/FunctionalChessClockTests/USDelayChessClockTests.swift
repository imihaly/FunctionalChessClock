//
// USDelayChessClockTests.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import XCTest
@testable import FunctionalChessClock

final class USDelayChessClockTests: XCTestCase {

    func testThatUpdatingForZeroSecondsWillNotChangeTimeValue() throws {
        let result = USDelayChessClock(totalTime: .seconds(100), delayValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(10))
        
        XCTAssertEqual(result.timeValue, .seconds(100))
    }

    func testThatUpdatingForLessThanDelayWillNotChangeTimeValue() throws {
        let result = USDelayChessClock(totalTime: .seconds(100), delayValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(12))
        
        XCTAssertEqual(result.timeValue, .seconds(100))
    }

    func testThatUpdatingForMoreThanDelayWillChangeTimeValueAppropriately() throws {
        let result = USDelayChessClock(totalTime: .seconds(100), delayValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(20))
        
        XCTAssertEqual(result.timeValue, .seconds(95))
    }
    
    func testThatUpdatingForMoreSecondsThenTimeValueWillTerminate() throws {
        let result = USDelayChessClock(totalTime: .seconds(100), delayValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .update(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(5))
        XCTAssertTrue(result.isFinal)
    }
    
    func testThatCommittingUpdateAfterMoreSecondsThenTimeValueWillTerminate() throws {
        let result = USDelayChessClock(totalTime: .seconds(100), delayValue: .seconds(5))
            .beginUpdates(time: .seconds(10))
            .endUpdates(time: .seconds(120))
        
        XCTAssertEqual(result.timeValue, .seconds(0))
        XCTAssertEqual(result.leftoverTime, .seconds(5))
        XCTAssertTrue(result.isFinal)
    }

}
