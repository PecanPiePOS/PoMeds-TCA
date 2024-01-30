//
//  HomeView.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import SwiftUI

import ComposableArchitecture

struct HomeView: View {
    private let store: StoreOf<HomeReducer>
    @ObservedObject private var viewStore: ViewStoreOf<HomeReducer>
    
    init(store: StoreOf<HomeReducer>) {
        self.store = store
        self.viewStore = ViewStore(self.store, observe: { $0 })
    }
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            VStack {
                
            }
        } destination: { pathState in
            switch pathState {
            case .registerNewMedicationScene:
                CaseLet(\HomeReducer.Path.State.registerNewMedicationScene, action: HomeReducer.Path.Action.registerNewMedication, then: <#T##(Store<CaseState, CaseAction>) -> View##(Store<CaseState, CaseAction>) -> View##(_ store: Store<CaseState, CaseAction>) -> View#>)
            case .listOfOngoingMedicationScene:
            case .listOfPastMedicationScene:
            case .myPageScene:
            case .manageSideEffectsScene:
            }
        }
        .toolbarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image("logoLight")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("PoMeds")
                        .font(.largeTitle)
                }
            }
        }
    }
}

//#Preview {
//    HomeView(store: <#T##StoreOf<HomeReducer>#>)
//}
