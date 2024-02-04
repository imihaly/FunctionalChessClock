//
// SettingsView.swift
//
// Created by Imre Mihaly on 2024.
//
// All rights reserved.
//


import SwiftUI
import FunctionalChessClock

enum IncrementType: String, Hashable, CaseIterable {
    case none
    case fischer = "Fischer Increment"
    case bronstein = "Bronstein Increment"
    case usDelay = "Delay"
}


struct SettingsView: View {
    var model: ChessClockModel
    
    @State
    var time: String = "180"

    @State
    var incrementType: IncrementType = .none

    @State
    var increment: String = "10"

    @Binding
    var navigationPath: NavigationPath
    
    var body: some View {
        VStack {
            HStack {
                Text("Time:")
                    .frame(width: 100, alignment: .leading)
                TextField("", text: $time)
                    .padding(4.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            .padding(.horizontal)
            HStack {
                Text("Increment:")
                    .frame(width: 100, alignment: .leading)
                Spacer()
                Picker("Please choose increment", selection: $incrementType.animation()) {
                    ForEach(IncrementType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .padding(4.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.blue, lineWidth: 2)
                )
            }
            .padding(.horizontal)
            
            if incrementType != .none {
                HStack {
                    Text("Value:")
                        .frame(width: 100, alignment: .leading)
                    TextField("", text: $increment)
                        .padding(4.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .padding(.horizontal)
            }
            
            Button {
                onCommit()
            } label: {
                HStack {
                    Spacer()
                    Text("Set")
                    Spacer()
                }
            }
            .padding(.vertical)
            .background {
                Color.gray
            }

            Spacer()
        }
    }
    
    private func onCommit() {
        guard let totalTime = parseTimeString(self.time) else {
            return
        }

        var increment = 0.0
        if let value = Int(self.increment) {
            increment = Double(value)
        }

        var clock: ChessClock = PlainChessClock(totalTime: totalTime)
        switch incrementType {
        case .none:
            break
        case .fischer:
            clock = FischerIncrementChessClock(totalTime: totalTime, incrementValue: .seconds(increment))
        case .bronstein:
            clock = BronsteinIncrementChessClock(totalTime: totalTime, incrementValue: .seconds(increment))
        case .usDelay:
            clock = USDelayChessClock(totalTime: totalTime, delayValue: .seconds(increment))
        }
        
        model.reset(to: clock)
        navigationPath.removeLast()
    }
    
    private func parseTimeString(_ str: String) -> TimeValue? {
        let components = str.split(separator: ":").map {
            $0.trimmingCharacters(in: .whitespaces)
        }.compactMap {
            Int($0)
        }.map {
            Double($0)
        }
        
        switch components.count {
        case 1:
            // they must be seconds
            return .seconds(components[0])
        case 2:
            // they must be minutes:seconds
            return .minutes(components[0]) + .seconds(components[1])
        case 3:
            // they must be hours:minutes:seconds
            return .hours(components[0]) + .minutes(components[1]) + .seconds(components[2])
        default:
            break
        }
        
        return nil
    }
}
