//
//  HomeMedicineTitleView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/2/24.
//

import SwiftUI

import ComposableArchitecture

struct HomeMedicineTitleView: View {
    @State var store: StoreOf<HomeReducer>
    
    var body: some View {
        ZStack {
            if store.takingMedicationList.isEmpty {
                VStack {
                    Text("현재 복용하고\n있는 약이 없어요.")
                        .font(.system(size: 17, weight: .light))
                        .foregroundStyle(Color(hex: "FFBE98"))
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack {
                    Text("복용 중")
                        .font(.system(size: 17, weight: .light))
                        .foregroundStyle(Color(hex: "FFBE98"))
                    ForEach(store.takingMedicationList.prefix(3), id: \.self) {
                        Text($0.reasonForMedication)
                            .font(.system(size: 20, weight: .heavy))
                            .foregroundStyle(Color(hex: "9E7463"))
                    }
                }
            }
            
            if store.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color(hex: "FFBE98"))
                    .controlSize(.large)
            }
        }
    }
}
