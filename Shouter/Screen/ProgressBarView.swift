//
//  ProgressBarView.swift
//  Shouter
//
//  Created by Diki Dwi Diro on 06/05/24.
//

import SwiftUI

struct ProgressBarView: View {
    
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

#Preview {
    ProgressBarView(progress: .constant(1))
}
