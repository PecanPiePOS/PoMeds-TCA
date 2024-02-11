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
        VStack(alignment: .leading) {
            HStack {
                Text("복용 기간")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
                Text("\(store.startDate) ~ \(store.endDate)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
            }
            
            HStack {
                Text("내게 발생한 부작용")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.black)
                Spacer()
                Text(store.sideEffects.isEmpty ? "없음": "\(store.sideEffects.count)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .padding(15)
        .navigationTitle(store.medicationTitle)
        .navigationBarTitleDisplayMode(.large)
//        .toolbar {
//            ToolbarItem(placement: .topBarLeading) {
//                Button(action: {
//                    store.send(.a)
//                }, label: {
//                    Text("삭제")
//                        .font(.system(size: 17, weight: .medium))
//                        .foregroundStyle(.red)
//                })
//            }
//        }
    }
}

//#Preview {
//    CommonDetailListView(store: Store(initialState: CommonDetailListReducer.State(medicationTitle: "약1", isOngoing: true, id: ObjectId("aa")), reducer: {
//        CommonDetailListReducer()
//    }))
//}
