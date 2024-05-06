//
//  TimesUpScreen.swift
//  Shouter
//
//  Created by Benedick Wijayaputra on 01/05/24.
//

import SwiftUI

struct TimesUpView: View {
    
    @Binding var isShowARContainerView: Bool
    @Binding var isTimerRunning: Bool
    @Binding var progressBarValue: Float
        
    let fourColumnsGridItems: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let basketballManager: BasketballManager = BasketballManager.shared
    let highScore = UserDefaults.standard.integer(forKey: "highScore")
    
    var body: some View {
        createBackgroundPopupMenu()
            .overlay {
                VStack {
                    createHighScore()
                    
                    createTotalScore()
                    
                    HStack(spacing: 34) {
                        createRestartButton()
                        
                        createHomeButton()
                    }
                }
                .offset(y: -10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black.opacity(0.6))
            .onAppear {
                checkHighScore()
            }
    }
    
    private func checkHighScore() {
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        if basketballManager.totalScore >= highScore {
            UserDefaults.standard.setValue(basketballManager.totalScore, forKey: "highScore")
        }
    }
    
    @ViewBuilder private func createHomeButton() -> some View {
        Button {
            withAnimation {
                isShowARContainerView = false
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
    
    @ViewBuilder private func createTotalScore() -> some View {
        RoundedRectangle(cornerRadius: 50)
            .fill(.customWhite)
            .frame(width: 130, height: 60)
            .overlay {
                HStack {
                    Image(.allBody)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .offset(y: 2)
                    
                    Text("\(BasketballManager.shared.totalScore)")
                        .font(.system(.title, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .padding(.bottom)
    }
    
    @ViewBuilder private func createHighScore() -> some View {
        Image("crown")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150)
            .offset(y: 19)
        
        RoundedRectangle(cornerRadius: 50)
            .fill(.customWhite)
            .frame(width: 170, height: 63)
            .overlay {
                HStack {
                    Image("ball-crown")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .offset()
                    
                    Text("\(highScore)")
                        .font(.system(.largeTitle, weight: .heavy))
                        .foregroundStyle(.black)
                }
                .offset(x: -15)
            }
    }
    
    @ViewBuilder private func createBackgroundPopupMenu() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 300, height: 300)
            .background(Color(red: 0.09, green: 0.11, blue: 0.18))
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
    TimesUpView(isShowARContainerView: .constant(false), isTimerRunning: .constant(false), progressBarValue: .constant(0))
}
