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
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var medicationTitle: String
        var isOngoing: Bool
        let id: ObjectId
        var medicineDetailList: [MedicineName] = []
        
        var isLoading = false
    }
    
    enum Action {
        case onAppear
        case deleteDidTap
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case deleteConfrimed
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .deleteDidTap:
                return .none
            case .alert:
                return .none
            }
        }
    }
}
