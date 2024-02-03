//
//  SettingDetailOfMedicationView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/5/24.
//

import SwiftUI

import ComposableArchitecture

struct SettingDetailOfMedicationView: View {
    @State var store: StoreOf<SettingDetailOfMedicationReducer>
    
    var body: some View {
        ZStack {
            Color(hex: "FBFBFB").ignoresSafeArea()
            
            VStack {
                List {
                    ForEach(store.listOfNames, id: \.self) { names in
                        Text(names)
                    }
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

//#Preview {
//    SettingDetailOfMedicationView()
//}
