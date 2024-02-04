//
//  ChessClockModel.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//

import Foundation

public class ChessClockModel: ObservableObject {

    public enum State {
        case initial
        case running
        case paused
        case stopped
    }
    
    public enum Side {
        case none
        case white
        case black
    }
    
    @Published
    public var state: State = .initial
    
    @Published
    public var whiteClock: ChessClock
    
    @Published
    public var blackClock: ChessClock
    
    @Published
    public var activeSide: Side = .none

    private var originalWhiteClock: ChessClock
    private var originalBlackClock: ChessClock

    private var clock = BaseClock()
    private var updateFrequency: Int = 10
    private var updateTimer: Timer?
    
    public convenience init(clock: ChessClock, updateFrequency: Int = 10) {
        self.init(whiteClock: clock, blackClock: clock)
    }
    
    public init(whiteClock: ChessClock, blackClock: ChessClock, updateFrequency: Int = 10) {
        assert(updateFrequency > 0)
        
        self.whiteClock = InactiveChessClock(clockToActivate: whiteClock)
        self.blackClock = InactiveChessClock(clockToActivate: blackClock)
        self.originalWhiteClock = whiteClock
        self.originalBlackClock = blackClock
        self.updateFrequency = updateFrequency
    }
    
    // Starts the process by activating white's clock.
    public func start() {
        assert(state == .initial)
        
        state = .running
        clock.start()
        let time = clock.getTime()
        
        activeSide = .white
        whiteClock = whiteClock.activate(time: time)
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / Double(updateFrequency), repeats: true, block: { _ in
            self.update()
        })
    }
    
    // Stops the process by deactivating both clocks.
    public func stop() {
        assert(state == .running ||
               state == .paused
        )
        
        let time = clock.getTime()
        updateTimer?.invalidate()
        whiteClock = whiteClock.deactivate(time: time)
        blackClock = blackClock.deactivate(time: time)
        activeSide = .none
        
        clock.stop()
        state = .stopped
    }
    
    // Resets the model into the original state, after which it can be restarted.
    public func reset() {
        assert(state == .stopped)
        self.whiteClock = InactiveChessClock(clockToActivate: originalWhiteClock)
        self.blackClock = InactiveChessClock(clockToActivate: originalBlackClock)
        state = .initial
    }

    // Resets the clock to a different setup.
    public func reset(to clock: ChessClock) {
        reset(whiteClock: clock, blackClock: clock)
    }
    
    // Resets the clock to a different setup.
    public func reset(whiteClock: ChessClock, blackClock: ChessClock) {
        if self.state != .initial && self.state != .stopped {
            self.stop()
        }

        self.whiteClock = InactiveChessClock(clockToActivate: whiteClock)
        self.blackClock = InactiveChessClock(clockToActivate: blackClock)
        self.originalWhiteClock = whiteClock
        self.originalBlackClock = blackClock
        state = .initial
    }
    
    // deactivates the running side and activates the other one.
    public func switchSides() {
        assert(state == .running)
        
        let time = clock.getTime()
        
        switch(activeSide) {
            
        case .none:
            assert(false)
        case .white:
            whiteClock = whiteClock.deactivate(time: time)
            blackClock = blackClock.activate(time: time)
            activeSide = .black
        case .black:
            whiteClock = whiteClock.activate(time: time)
            blackClock = blackClock.deactivate(time: time)
            activeSide = .white
        }
    }
    
    // Halts the clocks but will not manipulates the sides.
    public func pause() {
        assert(state == .running)
        clock.pause()
        state = .paused
    }
    
    // Resumes the clocks from a paused state.
    public func resume() {
        assert(state == .paused)
        clock.resume()
        state = .running
    }
    
    // Performs the updates on both sides' clock.
    private func update() {
        let time = clock.getTime()
        
        whiteClock = whiteClock.update(time: time)
        if whiteClock.isFinal {
            stop()
            return
        }

        blackClock = blackClock.update(time: time)
        if blackClock.isFinal {
            stop()
            return
        }
    }
}
