//
//  TimesUpScreen.swift
//  Shouter
//
//  Created by Benedick Wijayaputra on 01/05/24.
//

import SwiftUI

struct TimesUpScreen: View {
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 297, height: 254)
                .background(Color(red: 0.09, green: 0.11, blue: 0.18))
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                )
            
            VStack{
                Image("Crown")
                    .resizable()
                    .frame(width: 65, height: 50, alignment: .center)
                    .offset(y: -80)
        
            }
            
            VStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 205, height: 43.02469)
                  .background(Color(red: 0.92, green: 0.89, blue: 0.85))
                  .cornerRadius(21.09053)
                  .offset(y: -35)
                }
            
            VStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 181, height: 38.06075)
                  .background(Color(red: 0.92, green: 0.89, blue: 0.85))
                  .cornerRadius(21.09053)
                  .offset(y: 13)
                }
                
                HStack(spacing: 34) {
                    Button(action: {}, label: {
                        Image("Replay Button")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .offset(y: 75)
                    })
                    
                    Button(action: {}, label: {
                        Image("Home Button")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .offset(y: 75)
                    })
                    

                }
            }
        }
    }


#Preview {
    TimesUpScreen()
}
