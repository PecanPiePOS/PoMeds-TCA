//
//  ListOfOngoingMedicationsReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

struct MedicationListModel: Equatable {
    var _id: ObjectId
    var medicationTitle: String
}

@Reducer
struct SomeFeature {
    typealias MedicationData = MedicationRecordItem
    
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
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let ongoingList = try await self.database.fetchOngoingMeications()
                    let pastList = try await self.database.fetchPastMedications()
                    await send(.medicationListResponse(ongoingList))
                    await send(.supplementsListResponse(pastList))
                }
            case let .medicationListResponse(list):
                state.ongoingMedicationList = list
                return .none
            case let .supplementsListResponse(list):
                state.ongoingSupplementList = list
                return .none
            }
        }
    }
}
