//
//  CommonDetailListReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

@Reducer
struct CommonDetailListReducer {
    typealias MedicineName = String
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.medicationDatabase) var database
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var medicationTitle: String
        var isOngoing: Bool
        let itemId: ObjectId
        var medicineDetailList: [MedicineName] = []
        var startDate: Date = Date()
        var endDate: Date = Date()
        var sideEffects: [String] = []
        
        var isLoading = false
        var hasErrorOccured = false
    }
    
    enum Action {
        case onAppear
        case medicineDataFound(MedicationRecord)
        case fetchingDataFailed
        case deleteDidTap
        case alert(PresentationAction<Alert>)
        case deleteConfirmed
        case deleteFailed
        enum Alert: Equatable {
            case confirmDelete
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [id = state.itemId] send in
                    let data = try await self.database.fetchObjectWithId(id)
                    if let data {
                        await send(.medicineDataFound(data))
                    } else {
                        await send(.fetchingDataFailed)
                    }
                }
                
            case let .medicineDataFound(medicine):
                state.medicineDetailList = Array(medicine.pillNames)
                state.startDate = medicine.startDate
                state.endDate = medicine.endDate
                state.sideEffects = Array(medicine.sideEffects)
                state.isLoading = false
                return .none
                
            case .fetchingDataFailed:
                state.hasErrorOccured = true
                state.isLoading = false
                return .none

            case .deleteDidTap:
                state.alert = AlertState {
                    TextState("해당 복용 기록을 삭제하시나요?")
                } actions: {
                    ButtonState(action: .send(.confirmDelete)) {
                        TextState("삭제")
                    }
                    ButtonState {
                        TextState("취소")
                    }
                } message: {
                    TextState("삭제하시면 다시 복구할 수 없어요.")
                }
                return .none
                
            case .deleteConfirmed:
                return .run { send in
                    await self.dismiss()
                }
                
            case .alert(.presented(.confirmDelete)):
                return .run { [id = state.itemId] send in
                    let success = try await database.delete(id: id)
                    if success {
                        await send(.deleteConfirmed)
                    }
                }
                
            case .deleteFailed:
                return .none
                
            case .alert:
                return .none
            
            }
        }
    }
}
