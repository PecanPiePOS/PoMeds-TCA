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
    
    @Dependency(\.medicationDatabase) var database
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var medicationTitle: String
        var isOngoing: Bool
        let id: ObjectId
        var medicineDetailList: [MedicineName] = []
        var startDate: Date = Date()
        var endDate: Date = Date()
        var sideEffects: [String] = []
        
        var isLoading = false
        var hasErrorOccured = false
    }
    
    enum Action {
        case onAppear
        case medicineDataFound(MedicationRecordItem)
        case fetchingDataFailed
        case deleteDidTap
        case alert(PresentationAction<Alert>)
        case deleteConfirmed
        
        enum Alert: Equatable {
            case deleteConfrimed
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [id = state.id] send in
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
                    ButtonState(action: .send(.deleteConfrimed)) {
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
                return .none
                
            case .alert(.presented(.deleteConfrimed)):
                return .run { [id = state.id] send in
                    // TODO: 삭제 성공 및 실패 케이스를 나눠야 하는 UI 를 그려야 함
                    _ = try await database.delete(id: id)
                    await send(.deleteConfirmed)
                }
                
            case .alert:
                return .none
            
            }
        }
    }
}
