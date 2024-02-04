//
//  BaseClock.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

public struct TimeValue: Equatable {
    public var seconds: Double
    
    public init(_ seconds: Double) {
        self.seconds = seconds
    }

    public init(_ seconds: Float) {
        self.init(Double(seconds))
    }

    public init(_ seconds: Int) {
        self.init(Double(seconds))
    }

    public static func seconds(_ s: Double) -> TimeValue {
        TimeValue(s)
    }
    
    public static func minutes(_ m: Double) -> TimeValue {
        TimeValue(m * 60)
    }
    
    public static func hours(_ h: Double) -> TimeValue {
        TimeValue(h * 60 * 60)
    }
    
    public static func +(lhs: TimeValue, rhs: TimeValue) -> TimeValue {
        .seconds(lhs.seconds + rhs.seconds)
    }
    
    public static func -(lhs: TimeValue, rhs: TimeValue) -> TimeValue {
        .seconds(lhs.seconds - rhs.seconds)
    }
    
    public static func ==(lhs: TimeValue, rhs: TimeValue) -> Bool {
        lhs.seconds == rhs.seconds
    }

    public static func <(lhs: TimeValue, rhs: TimeValue) -> Bool {
        lhs.seconds < rhs.seconds
    }
    
    public static func <=(lhs: TimeValue, rhs: TimeValue) -> Bool {
        lhs.seconds <= rhs.seconds
    }
    
    public static func >(lhs: TimeValue, rhs: TimeValue) -> Bool {
        lhs.seconds >= rhs.seconds
    }
    
    public static func >=(lhs: TimeValue, rhs: TimeValue) -> Bool {
        lhs.seconds >= rhs.seconds
    }
}

public class BaseClock {
    
    enum State {
        case initial
        case started(accumulatedTime: TimeValue, date: Date)
        case paused(accumulatedTime: TimeValue)
    }
    
    private var state: State = .initial
    
    func getTime() -> TimeValue {
        switch(state) {
        case .initial:
            return .seconds(0)
        case .started(accumulatedTime: let accumulatedTime, date: let date):
            return accumulatedTime + .seconds(Date().timeIntervalSince(date))
        case .paused(accumulatedTime: let accumulatedTime):
            return accumulatedTime
        }
    }
    
    func start() {
        switch(state) {
        case .initial:
            state = .started(accumulatedTime: .seconds(0), date: Date())
        case .started(accumulatedTime: _, date: _), .paused(accumulatedTime: _):
            assert(false)
        }
    }
        
    func pause() {
        switch(state) {
        case .started(accumulatedTime: _, date: _):
            state = .paused(accumulatedTime: getTime())
        case .initial, .paused(accumulatedTime: _):
            assert(false)
        }
    }
    
    func resume() {
        switch(state) {
            
        case .initial, .started(accumulatedTime: _, date: _):
            assert(false)
        case .paused(accumulatedTime: let accumulatedTime):
            state = .started(accumulatedTime: accumulatedTime, date: Date())
        }
    }
    
    func stop() {
        state = .initial
    }
}
