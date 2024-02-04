//
//  ContentView.swift
//  ChessClock
//
//  Created by Imre Mihaly on 22/01/2024.
//

import SwiftUI
import FunctionalChessClock

struct ContentView: View {
    @StateObject 
    var model = ChessClockModel(clock: PlainChessClock(totalTime: .minutes(3)))
    let fontName = "digital-7 mono"
    let fontSize = 100.0
    
    @State
    var navigationPath: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                blackClock()
                    .rotationEffect(.degrees(180))
                buttons()
                whiteClock()
            }
        }
    }
    
    @ViewBuilder
    private func whiteClock() -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(self.formatTime(time: model.whiteClock.timeValue))")
                    .font(Font.custom(fontName, size: fontSize))
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(model.activeSide == .white ? .blue : .black)
        .background {
            model.whiteClock.isFinal ? Color.red : Color.white
        }
        .border(Color.black)
        .contentShape(Rectangle())
        .onTapGesture {
            if model.activeSide == .white {
                clockTapped()
            }
        }
    }

    @ViewBuilder
    private func blackClock() -> some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(self.formatTime(time: model.blackClock.timeValue))")
                    .font(Font.custom(fontName, size: fontSize))
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(model.activeSide == .black ? .blue : .white)
        .background() {
            model.blackClock.isFinal ? Color.red : Color.black
        }
        .border(Color.gray)
        .contentShape(Rectangle())
        .onTapGesture {
            if model.activeSide == .black {
                clockTapped()
            }
        }
    }
    
    @ViewBuilder
    private func buttons() -> some View {
        HStack {
            if model.state == .initial {
                Button(action: {
                    model.start()
                }, label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                })
            }
            
            if model.state == .running {
                Button(action: {
                    model.pause()
                }, label: {
                    Image(systemName: "pause.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                })
            }
            
            if model.state == .paused {
                Button(action: {
                    model.resume()
                }, label: {
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                })
            }
            
            if model.state == .running || model.state == .paused {
                Button(action: {
                    model.stop()
                }, label: {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                })
            }
            if model.state == .stopped {
                Button(action: {
                    model.reset()
                }, label: {
                    Image(systemName: "repeat.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                })
            }
            if model.state == .initial || model.state == .stopped {
                NavigationLink(value: 0) {
                    Image(systemName: "gear.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(height: 50)
        .navigationDestination(for: Int.self) { _ in
            SettingsView(model: self.model, navigationPath: $navigationPath)
        }
    }

    private func clockTapped() {
        if model.state == .running {
            model.switchSides()
        }
    }
    
    private func formatTime(time: TimeValue) -> String {
        let timeInSeconds = Int(time.seconds.rounded(.up))
        let seconds = timeInSeconds % 60
        var minutes = timeInSeconds / 60
        let hours = minutes / 60
        minutes %= 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

