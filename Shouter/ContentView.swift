//
//  ContentView.swift
//  BasketballAR
//
//  Created by Diki Dwi Diro on 24/04/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    
    @State private var isHoopEntityPlaced: Bool = false
    @State private var shootBall: Bool = false
    @State private var isOnVerticalPlane: Bool = false
    
    var screenOverlayGradientColor: RadialGradient {
        RadialGradient(colors: [isOnVerticalPlane ? .green : .red, .clear],
                       center: .center,
                       startRadius: 600,
                       endRadius: 200)
    }


    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewRepresentable(isOnVerticalPlane: $isOnVerticalPlane, isHoopEntityPlaced: $isHoopEntityPlaced, shootBall: $shootBall)
                .ignoresSafeArea()
                .onTapGesture {
                    isHoopEntityPlaced = true
                }
                .disabled(isHoopEntityPlaced)
//                .overlay {
//                    Rectangle()
//                        .fill(screenOverlayGradientColor)
//                        .ignoresSafeArea()
//                }
            
            if isHoopEntityPlaced {
                VStack {
                    Button {
                        shootBall = true
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
        }
    }
}

#Preview {
    ContentView()
}
