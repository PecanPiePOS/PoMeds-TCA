//
//  ListOfOngoingMedicationsView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import SwiftUI

import ComposableArchitecture

struct ListOfOngoingMedicationsView: View {
    @State var store: StoreOf<ListOfOngoingMedicationsReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ListOfOngoingMedicationsView(store: Store(initialState: ListOfOngoingMedicationsReducer.State(), reducer: {
        ListOfOngoingMedicationsReducer()
    }))
}
