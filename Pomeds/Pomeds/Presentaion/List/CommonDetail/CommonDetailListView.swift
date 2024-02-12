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
        ScrollView {
            ZStack {
                LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(store.medicineDetailList, id: \.self) { item in
                            Text("💊 \(item)")
                                .padding()
                                .foregroundStyle(.black)
                                .font(.system(size: 17, weight: .bold))
                        }
                    } header: {
                        CommonDetailHeaderView(startDate: store.startDate, endDate: store.endDate, sideEffects: store.sideEffects)
                            .background(.white)
                            .padding(.bottom, 10)
                            .padding(.horizontal, 15)
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
        .alert(store: self.store.scope(state: \.$alert, action: \.alert))
        .navigationTitle(store.medicationTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
            print("📌", store.itemId)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    store.send(.deleteDidTap)
                }, label: {
                    Text("삭제")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.red)
                })
            }
        }
//        .onAppear {
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = UIColor.blue // Set your desired color
//            
//            // Customize navigation bar title color
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//            
//            // Apply the appearance settings to specific navigation bar instances
//            UINavigationBar.appearance().standardAppearance = appearance
//            UINavigationBar.appearance().compactAppearance = appearance // Optional
//            UINavigationBar.appearance().scrollEdgeAppearance = appearance
//        }
        
        
//        .navigationback
//        .clipped()


    }
}

//#Preview {
//    CommonDetailListView(store: Store(initialState: CommonDetailListReducer.State(medicationTitle: "약1", isOngoing: true, id: ObjectId("aa")), reducer: {
//        CommonDetailListReducer()
//    }))
//}
