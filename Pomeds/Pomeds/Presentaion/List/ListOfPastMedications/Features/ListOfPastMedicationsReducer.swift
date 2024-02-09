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
    typealias MedicationData = MedicationRecordItem
    
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
                    let pastList = try await self.database.fetchPastMedications()
                    await send(.medicationListResponse(pastList.filter({ $0.medicationType == "med" })))
                    await send(.supplementsListResponse(pastList.filter{ $0.medicationType == "suppl" }))
                }
            case let .medicationListResponse(list):
                state.pastMedicationList = list
                return .none
            case let .supplementsListResponse(list):
                state.pastSupplementList = list
                return .none
            case let .cellDidTapWith(id, title):
                return .none
            }
        }
    }
}
