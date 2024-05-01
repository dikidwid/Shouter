//
//  ContentView.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @State private var isShootFired: Bool = false
    @State private var isOnVerticalPlane: Bool = false
    @State private var isHoopEntityPlaced: Bool = false
    
    @StateObject var basketballManager: BasketballManager = BasketballManager.shared
    
    var arManager: ARManager = ARManager.shared
    
    var screenOverlayGradientColor: RadialGradient {
        RadialGradient(colors: [isOnVerticalPlane ? .green : .red, .clear],
                       center: .center,
                       startRadius: 600,
                       endRadius: 200)
    }


    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewRepresentable()
                .ignoresSafeArea()
                .onTapGesture {
                    arManager.actionStream.send(.placeHoop)
                }
            
            VStack {
                Text("Score \(basketballManager.totalScore)")
                    .font(.title)
                    .padding()
                
                Spacer()
                
                Button {
                    arManager.actionStream.send(.shootBall)
                } label: {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 71))
                        .foregroundStyle(.orange)
                        .padding()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            setUpAudioCapture()
        }
    }
}

#Preview {
    ContentView()
}
