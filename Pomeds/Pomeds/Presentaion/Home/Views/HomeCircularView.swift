//
//  HomeCircularView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/1/24.
//

import SwiftUI

import ComposableArchitecture
import Lottie

struct HomeCircularView: View {
    @State var store: StoreOf<HomeReducer>
    
    var body: some View {
        ZStack {
            LottieView(animation: .named("home2"))
                .animationSpeed(0.8)
                .looping()
                .scaleEffect(1.6)
            
            if store.takingMedicationList.isEmpty {
                VStack {
                    Text("현재 복용하고\n있는 약이 없어요.")
                        .font(.system(size: 17, weight: .light))
                        .foregroundStyle(Color(hex: "D0AE9F"))
                        .multilineTextAlignment(.center)
                        .opacity(store.isLoading ? 0.4: 1)
                }
            } else {
                VStack {
                    Text("복용 중")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color(hex: "FFBE98"))
                        .padding(2)
                    ForEach(store.takingMedicationList.prefix(3), id: \.self) {
                        Text($0.reasonForMedication)
                            .font(.system(size: 20, weight: .bold))
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

#Preview {
    HomeCircularView(store: PomedsApp.store)
}
