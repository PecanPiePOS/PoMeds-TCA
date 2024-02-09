//
//  ListOfPastMedicationsView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import SwiftUI

import ComposableArchitecture

struct ListOfPastMedicationsView: View {
    @State var store: StoreOf<ListOfPastMedicationsReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ListOfPastMedicationsView(store: Store(initialState: ListOfPastMedicationsReducer.State(), reducer: {
        ListOfPastMedicationsReducer()
    }))
}
