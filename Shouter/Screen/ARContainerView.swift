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
    
    @State private var isHandTapAnimating: Bool = false
    
    @StateObject var basketballManager: BasketballManager = BasketballManager.shared
    
    var arManager: ARManager = ARManager.shared
    
    var body: some View {
        ZStack {
            createARViewContainer()
                        
            if basketballManager.isShowGameOverlay {
                    
                createSoundMeterBarIndicator()
                    
                createShootBallButton()
                
                createGameView()
            } else {
                createPlaceHoopButton()
            }
        }
        .overlay {
            if basketballManager.isPaused {
                showPausedPopupMenu()
            }
            
            if basketballManager.progressBarValue >= 1 {
                showTimesPopupMenu()
            }
        }
    }
    
    @ViewBuilder private func showTimesPopupMenu() -> some View {
        TimesUpView(isShowARContainerView: $isShowARContainerView,
                    isTimerRunning: $basketballManager.isTimerRunning,
                    progressBarValue: $basketballManager.progressBarValue)
    }
    
    @ViewBuilder private func showPausedPopupMenu() -> some View {
        PauseView(isShowARCointainerView: $isShowARContainerView,
                  isMuted: $isMuted,
                  isPaused: $basketballManager.isPaused,
                  isTimerRunning: $basketballManager.isTimerRunning,
                  progressBarValue: $basketballManager.progressBarValue)
    }
    
    @ViewBuilder private func createGameView() -> some View {
        GameView(isPaused: $basketballManager.isPaused,
                 isTimerRunning: $basketballManager.isTimerRunning,
                 progressBarValue: $basketballManager.progressBarValue)
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
    
    @ViewBuilder private func createPlaceHoopButton() -> some View {
        Button {
            basketballManager.isTimerRunning = true
            arManager.actionStream.send(.placeHoop)
        } label: {
            Image(systemName: "plus.viewfinder")
                .font(.system(size: 71))
                .foregroundStyle(.orange)
                .symbolEffect(.bounce, options: .repeating, value: isHandTapAnimating)
                .onAppear {
                    isHandTapAnimating.toggle()
                }
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .opacity(basketballManager.isHoopPlaceAble ? 1 : 0)
    }
    
    @ViewBuilder private func createARViewContainer() -> some View {
        ARViewRepresentable()
            .ignoresSafeArea()
            .overlay {
                Group {
                    if basketballManager.isHoopPlaceAble {
                        Color.green.opacity(0.4)
                    } else {
                        Color.red.opacity(0.4)
                    }
                }
                .ignoresSafeArea()
                .opacity(basketballManager.isHoopEntityPlaced ? 0 : 1)
            }
    }
}

#Preview {
    ARContainerView(isShowARContainerView: .constant(false), isMuted: .constant(false))
}

