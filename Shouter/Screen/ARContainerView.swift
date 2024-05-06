//
//  ARContainerView.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI
import RealityKit

struct ARContainerView: View {
    
    @Binding var isShowARContainerView: Bool
    @Binding var isMuted: Bool
    
    @State private var isPaused: Bool = false
    @State private var isTimerRunning: Bool = true
    @State private var progressBarValue: Float = 0.0
    
    @State private var isHandTapAnimating: Bool = false
    
    @StateObject var basketballManager: BasketballManager = BasketballManager.shared
    
    var arManager: ARManager = ARManager.shared
    
    var body: some View {
        ZStack {
            createARViewContainer()
            
            if basketballManager.isHoopEntityPlaced {
                    
                createSoundMeterBarIndicator()
                    
                createShootBallButton()
                
                createGameView()
            }
        }
        .overlay {
            if isPaused {
                showPausedPopupMenu()
            }
            
            if progressBarValue >= 1 {
                showTimesPopupMenu()
            }
        }
    }
    
    @ViewBuilder private func showTimesPopupMenu() -> some View {
        TimesUpView(isShowARContainerView: $isShowARContainerView, isTimerRunning: $isTimerRunning, progressBarValue: $progressBarValue)
    }
    
    @ViewBuilder private func showPausedPopupMenu() -> some View {
        PauseView(isShowARCointainerView: $isShowARContainerView,
                  isMuted: $isMuted,
                  isPaused: $isPaused,
                  isTimerRunning: $isTimerRunning,
                  progressBarValue: $progressBarValue)
    }
    
    @ViewBuilder private func createGameView() -> some View {
        GameView(isPaused: $isPaused, isTimerRunning: $isTimerRunning, progressBarValue: $progressBarValue)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder private func createShootBallButton() -> some View {
        Button {
            arManager.actionStream.send(.shootBall)
        } label: {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 71))
                .foregroundStyle(.orange)
                .scaleEffect(basketballManager.isHoopEntityPlaced ? 1 : 1)
                .symbolEffect(.bounce, options: .repeating, value: isHandTapAnimating)
                .onAppear {
                        isHandTapAnimating.toggle()
                    
                }
                .padding()
        }
        .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder private func createSoundMeterBarIndicator() -> some View {
        Gauge (value: basketballManager.decible, in: -30...(0)) {
            Text("")
        }
        .tint(Gradient(colors: [.green, .yellow, .orange, .red]))
        .frame(maxWidth: .infinity, alignment: .trailing)
        .rotationEffect(Angle(degrees: -90), anchor: .center)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .offset(x: 150)
    }
    
    @ViewBuilder private func createARViewContainer() -> some View {
        ARViewRepresentable()
            .ignoresSafeArea()
            .onTapGesture {
                arManager.actionStream.send(.placeHoop)
            }
    }
}

#Preview {
    ARContainerView(isShowARContainerView: .constant(false), isMuted: .constant(false))
}

