//
//  CommonDetailListView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import SwiftUI

import ComposableArchitecture
import RealmSwift

struct CommonDetailListView: View {
    @State var store: StoreOf<CommonDetailListReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CommonDetailListView(store: Store(initialState: CommonDetailListReducer.State(medicationTitle: "약1", isOngoing: true, id: ObjectId("aa")), reducer: {
        CommonDetailListReducer()
    }))
}
