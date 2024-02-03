//
//  CommonCleanNextButtonView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/5/24.
//

import SwiftUI

struct CommonCleanNextButtonView: View {
    var buttonTitle: String
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(buttonTitle)
                .font(.system(size: 17, weight: .heavy))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding()
        .frame(height: 60)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
