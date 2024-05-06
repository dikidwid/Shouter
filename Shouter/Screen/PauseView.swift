//
//  PauseView.swift
//  Shouter
//
//  Created by Benedick Wijayaputra on 01/05/24.
//

import SwiftUI

struct PauseView: View {
    
    @Binding var isShowARCointainerView: Bool
    @Binding var isMuted: Bool
    
    @Binding var isPaused: Bool
    @Binding var isTimerRunning: Bool
    @Binding var progressBarValue: Float
    
    let audioPlayer: AudioPlayer = AudioPlayer()
    let basketballManager: BasketballManager = BasketballManager.shared
    
    var body: some View {
        ZStack {
           createBackgroundPopupMenu()
          
            VStack(spacing: 15) {
                createResumeButton()
                
                HStack(spacing: 34) {
                    createRestartButton()
                    
                    createHomeButton()
                    
                    createMuteButton()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.6))
    }
    
    @ViewBuilder private func createMuteButton() -> some View {
        Button {
            if isMuted {
                audioPlayer.playMusic()
                withAnimation {
                    isMuted = false
                }
            } else {
                audioPlayer.stopMusic()
                withAnimation {
                    isMuted = true
                }
            }
        } label: {
            Circle()
                .fill(.customWhite)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.3.fill")
                        .font(.system(.title2, weight: .bold))
                        .foregroundStyle(.customBlack)
                        .frame(width: 50, height: 50)
                }
        }
    }
    
    @ViewBuilder private func createHomeButton() -> some View {
        Button {
            withAnimation {
                isShowARCointainerView = false
                isPaused = false
                basketballManager.totalScore = 0
                basketballManager.isHoopEntityPlaced = false
            }
        } label: {
            Circle()
                .fill(.customWhite)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "house.fill")
                        .font(.system(.title2, weight: .bold))
                        .foregroundStyle(.customBlack)
                        .frame(width: 50, height: 50)
                }
        }
    }
    
    @ViewBuilder private func createRestartButton() -> some View {
        Button {
            withAnimation {
                isPaused = false
                isTimerRunning = true
                progressBarValue = 0.0
                basketballManager.totalScore = 0
            }
        } label: {
            Circle()
                .fill(.customWhite)
                .frame(width: 50, height: 50)
                .overlay {
                    Image("Replay Button")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .font(.system(.title2, weight: .bold))
                }
        }
    }
    
    @ViewBuilder private func createResumeButton() -> some View {
        Button {
            withAnimation {
                isPaused = false
                isTimerRunning = true
                
            }
        } label: {
            Image(systemName: "play.fill")
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.customBlack)
                .background {
                    Circle()
                        .fill(.customWhite)
                        .frame(width: 80, height: 80)
                }
                .padding(.bottom)
        }
        .padding()
    }
    
    @ViewBuilder private func createBackgroundPopupMenu() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 300, height: 220)
            .background(.customBlack)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .inset(by: 0.5)
                    .stroke(.black, lineWidth: 1)
            )
    }
}

#Preview {
    PauseView(isShowARCointainerView: .constant(true), isMuted: .constant(false), isPaused: .constant(false), isTimerRunning: .constant(false), progressBarValue: .constant(0))
}
