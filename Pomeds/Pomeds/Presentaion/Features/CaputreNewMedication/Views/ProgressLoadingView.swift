//
//  RecognizingLoadingView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import SwiftUI

struct ProgressLoadingView: View {
    var body: some View {
        ZStack {
            Color(hex: "D9D9D9").opacity(0.4).ignoresSafeArea()
            
            VStack {
                ProgressView()
                    .tint(Color(hex: "E1AC70").opacity(0.7))
                    .progressViewStyle(.circular)
                    .controlSize(.extraLarge)
                    .scaleEffect(1.6)
                    .shadow(color: Color(hex: "F69956"), radius: 3)
                    
                
                Text("인식 중...")
                    .foregroundStyle(Color(hex: "E1AC70"))
                    .padding(.top, 20)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
    }
}
