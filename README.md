# FunctionalChessClock

An experimental chess clock implementation, just for fun.

This library is not implementing a UI component but a chess clock model.
It is designed with a SwiftUI frontend in mind but the package is not containing any library implementation.
See the sample app for a primitive frontend.

The package's frontend class is `ChessClockModel`, but the interesting part was implementing the different clocks using
a functional approach. 

## How to use it:

```swift
var model = ChessClockModel(clock: PlainChessClock(totalTime: 180))

model.start() 
model.switchSide()
model.switchSide()
model.stop()

model.reset()
```

During operation clock states are puplished, one can listen to their changes.


## Supported features:

### 1. Different settings per side

```swift
// white got tree minutes, but black got only 2.
var model = ChessClockModel(whiteClock: PlainChessClock(totalTime: 180),
                            blackClock: PlainChessClock(totalTime: 120))
```

### 2. Sudden death timing:

Initializing with `PlainChessClock` creates a sudden deth setup, no delay, no increment.

```swift
var model = ChessClockModel(clock: PlainChessClock(totalTime: 180))
```

### 3. Fischer increment:

Setup is two minutes per side, 5 seconds increment after each turn:

```swift
var model = ChessClockModel(clock: FischerIncrementChessClock(totalTime: 120, incrementValue: 5))
```

### 3. Bronstein increment:

 With Bronstein increment the user gets back his time partially or in whole after each time.
 The increment applied is the time used but not more than the `incrementValue` 

```swift
var model = ChessClockModel(clock: BronsteinIncrementChessClock(totalTime: 120, incrementValue: 5))
```

### 4. US delay:

With this setup the clock is starting counting after the preset delay time:

```swift
var model = ChessClockModel(clock: USDelayChessClock(totalTime: 100, delayValue: 5))
```

### 5. Staged setup:

```swift
FischerIncrementChessClock(totalTime: 2 * 60 * 60, incrementValue: 30) // 2h+30s for the first stage (40 moves)
            .switchTo(nextStage: FischerIncrementChessClock(totalTime: 30 * 60, incrementValue: 30), afterMove: 40) // additianal 30 minutes after it till move 60
            .switchTo(nextStage: PlainChessClock(totalTime: 30 * 60), afterMove: 100) // sudden detah in the final stage
```

