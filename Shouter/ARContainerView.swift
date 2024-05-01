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
    
    @StateObject var basketballManager: BasketballManager = BasketballManager.shared
    
    var arManager: ARManager = ARManager.shared
    
    var body: some View {
        ZStack {
            //            ARViewRepresentable()
            //                .ignoresSafeArea()
            //                .onTapGesture {
            //                    arManager.actionStream.send(.placeHoop)
            //                }
            
//            Button {
//                arManager.actionStream.send(.shootBall)
//            } label: {
//                Image(systemName: "hand.tap.fill")
//                    .font(.system(size: 71))
//                    .foregroundStyle(.orange)
//                    .padding()
//            }
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//            
            GameView(isPaused: $isPaused, isTimerRunning: $isTimerRunning, progressBarValue: $progressBarValue)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .overlay {
            if isPaused {
                PauseView(isShowARCointainerView: $isShowARContainerView,
                          isMuted: $isMuted,
                          isPaused: $isPaused,
                          isTimerRunning: $isTimerRunning,
                          progressBarValue: $progressBarValue)
            }
        }
    }
}

#Preview {
    ARContainerView(isShowARContainerView: .constant(false), isMuted: .constant(false))
}

