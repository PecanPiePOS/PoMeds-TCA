//
//  ListOfOngoingMedicationsReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

struct MedicationListModel: Equatable, Identifiable {
    var id: ObjectId
    var medicationTitle: String
}

@Reducer
struct ListOfOngoingMedicationsReducer {
    typealias MedicationData = MedicationRecord
    
    @Dependency(\.medicationDatabase) var database
    
    @ObservableState
    struct State: Equatable {
        var ongoingMedicationList: [MedicationData] = []
        var ongoingSupplementList: [MedicationData] = []
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
                    let ongoingList = Array(try await self.database.fetchOngoingMedications())
                    await send(.medicationListResponse(ongoingList))
//                        .filter({ $0.medicationType == "med" })))
                    await send(.supplementsListResponse(ongoingList))
//                        .filter{ $0.medicationType == "suppl" }))
                }
            case let .medicationListResponse(list):
                state.ongoingMedicationList = list.filter { $0.medicationType == "med" }
                return .none
            case let .supplementsListResponse(list):
                state.ongoingSupplementList = list.filter { $0.medicationType == "suppl" }
                return .none
            case .cellDidTapWith:
                return .none
            }
        }
    }
}
