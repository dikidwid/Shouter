//
//  LandingPageView.swift
//  Shouter
//
//  Created by Benedick Wijayaputra on 01/05/24.
//

import SwiftUI

struct LandingPageView: View {
    
    @State private var isShowARContainerView: Bool = false
    @State private var isMuted: Bool = false
    @State private var isBallAnimating: Bool = false
    @State private var isShowAnimating: Bool = false
    @State private var isPlayButtonAnimating: Bool = false
    
    let audioPlayer: AudioPlayer = AudioPlayer()
    
    var body: some View {
        ZStack {
            createBackground()
            
            ZStack {
                createMuteButton()
                
                createPlayButton()
            }
            .opacity(isShowAnimating ? 1 : 0)
        }
        .onAppear {
            setUpAudioCapture()
            audioPlayer.playMusic()
            
            withAnimation(.easeInOut(duration: 3)) {
                isBallAnimating = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut) {
                    isShowAnimating = true
                    isPlayButtonAnimating.toggle()
                }
            }
        }
        .fullScreenCover(isPresented: $isShowARContainerView) {
            ARContainerView(isShowARContainerView: $isShowARContainerView,
                            isMuted: $isMuted)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder private func createPlayButton() -> some View {
        Button {
            isShowARContainerView = true
        } label: {
            Image("Play Button")
                .resizable()
                .frame(width: 280, height: 280)
                .shadow(color: .black.opacity(0.25), radius: 8.46977, x: 0, y: 16.93954)
                .offset(x: isPlayButtonAnimating ? 50 : 30, y: isPlayButtonAnimating ? -110 : -90)
                .animation(.easeInOut.repeatForever(autoreverses: true), value: isPlayButtonAnimating)
        }
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
                    Image(systemName: isMuted ? "speaker.slash.fill" :  "speaker.wave.3.fill")
                        .font(.system(.title2, weight: .bold))
                        .foregroundStyle(.customBlack)
                        .background {
                            
                        }
                        .padding()
                }
        }
        .padding([.leading, .top])
        .padding(.top, 35)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .animation(.easeInOut, value: isShowARContainerView)
    }
    
    @ViewBuilder private func createBackground() -> some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
        
        Image("ball 1")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .offset(y: isBallAnimating ? 0 : 390)
    }
}

#Preview {
    LandingPageView()
}
