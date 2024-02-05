//
//  HomeCTAButtonView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/2/24.
//

import SwiftUI

struct HomeCTAButtonView: View {
    var primaryText: String
    var secondaryText: String
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(primaryText)
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundStyle(.white)
                Text(secondaryText)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 14)
                .foregroundStyle(.white)
        }
        .padding()
        .frame(height: 60)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    HomeCTAButtonView(primaryText: "New Medication", secondaryText: "새로운 약 등록하기", backgroundColor: Color(hex: "FFBE98"))
}
