//
//  SwiftUIView.swift
//  Shouter
//
//  Created by Benedick Wijayaputra on 01/05/24.
//

import SwiftUI

struct GameView: View {
    
    @Binding var isPaused: Bool
    @Binding var isTimerRunning: Bool
    @Binding var progressBarValue: Float

    let totalTimer: CGFloat = 60
    
    let fourColumnsGridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            HStack {
                createPauseButton()
                
                createTimerBar()
                
                createRepositionButton()
            }
            
            createScoreIndicator()
        }
        .onAppear {
            updateTimerBar()
        }
    }
    
    private func updateTimerBar() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard isTimerRunning else { return }
            if progressBarValue >= 1.0 {
                isTimerRunning = false
            } else {
                withAnimation {
                    progressBarValue += Float(1 / totalTimer)
                }
            }
        }
    }
    
    @ViewBuilder private func createScoreIndicator() -> some View {
        LazyVGrid(columns: fourColumnsGridItems, alignment: .center) {
            ForEach(0..<BasketballManager.shared.totalScore, id: \.self) { index in
                Image(.allBody)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder private func createRepositionButton() -> some View {
        Button {
            progressBarValue = 0
            BasketballManager.shared.totalScore = 0
            BasketballManager.shared.isHoopEntityPlaced = false
            ARManager.shared.actionStream.send(.repositionHoop)
        } label: {
            Image(systemName: "arkit")
                .font(.system(.title2, weight: .bold))
                .foregroundStyle(.customBlack)
                .background {
                    Circle()
                        .fill(.customWhite)
                        .frame(width: 50, height: 50)
                }
                .padding()
        }
        .padding()
    }
    
    @ViewBuilder private func createTimerBar() -> some View {
        ProgressBarView(progress: $progressBarValue)
            .frame(height: 20)
    }
    
    @ViewBuilder private func createPauseButton () -> some View {
        Button {
            isTimerRunning = false
            withAnimation {
                isPaused = true
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.system(.title2, weight: .bold))
                .foregroundStyle(.customBlack)
                .background {
                    Circle()
                        .fill(.customWhite)
                        .frame(width: 50, height: 50)
                }
                .padding()
        }
        .padding()
    }
}

#Preview {
    GameView(isPaused: .constant(false), isTimerRunning: .constant(false), progressBarValue: .constant(0))
}


