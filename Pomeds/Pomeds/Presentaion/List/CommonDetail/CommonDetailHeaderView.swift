//
//  CommonDetailHeaderView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/11/24.
//

import SwiftUI

struct CommonDetailHeaderView: View {
    let startDate: Date
    let endDate: Date
    var sideEffects: [String]
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                Spacer()
                    .frame(height: 8)
                
                HStack {
                    Text("복용 기간")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                    Spacer()
                    Text("\(startDate.shortened) ~ \(endDate.shortened)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                HStack {
                    Text("내게 발생한 부작용")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.black)
                    Spacer()
                    Text(sideEffects.isEmpty ? "없음": "\(sideEffects.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                    .frame(height: 8)
            }
        }
    }
}
