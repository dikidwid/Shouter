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

    let totalTimer: CGFloat = 60.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Button {
                isTimerRunning = false
                withAnimation {
                    isPaused = true
                }
            } label: {
                Image(systemName: "gearshape")
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
            
            ProgressBar(progress: $progressBarValue)
                .frame(height: 20)
            
            Button {
                
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
        .onReceive(timer) { _ in
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
}

#Preview {
    GameView(isPaused: .constant(false), isTimerRunning: .constant(false), progressBarValue: .constant(0))
}

struct ProgressBar: View {
    
    @Binding var progress: Float
    
    let linearGradient: LinearGradient = LinearGradient(colors: [.red, .red,  .green, .green], startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                Rectangle()
                    .fill(linearGradient)
                    .frame(width: geometry.size.width , height: geometry.size.height)
                
                Rectangle()
                    .frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(.customBlack)
                    .animation(.linear, value: progress)
            }.cornerRadius(20)
        }
    }
}
