//
//  RegisterMedicationHelperReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct RegisterMedicationHelperReducer {
    
    @Dependency(\.dismiss) var dismiss
    
    @ObservableState
    struct State: Equatable {
        var someState: String = ""
    }
    
    enum Action {
        case someAction
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .someAction:
                return .none
            }
        }
    }
}
