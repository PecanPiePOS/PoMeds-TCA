//
//  ListOfPastMedicationsReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

@Reducer
struct ListOfPastMedicationsReducer {
    typealias MedicationData = MedicationRecord
    
    @Dependency(\.medicationDatabase) var database
    
    @ObservableState
    struct State: Equatable {
        var pastMedicationList: [MedicationData] = []
        var pastSupplementList: [MedicationData] = []
    }
    
    enum Action {
        case onAppear
        case medicationListResponse([MedicationData])
        case supplementsListResponse([MedicationData])
        
        case cellDidTapWith(id: ObjectId, title: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let pastList = Array(try await self.database.fetchPastMedications())
                    await send(.medicationListResponse(pastList))
                    await send(.supplementsListResponse(pastList))
                }
            case let .medicationListResponse(list):
                state.pastMedicationList = list.filter { $0.medicationType == "med" }
                return .none
            case let .supplementsListResponse(list):
                state.pastSupplementList = list.filter { $0.medicationType == "suppl" }
                return .none
            case .cellDidTapWith:
                return .none
            }
        }
    }
}
