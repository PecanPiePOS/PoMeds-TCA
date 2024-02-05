//
//  RegisterNewMedicationReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Foundation

import ComposableArchitecture

@Reducer
struct RegisterNewMedicationReducer {
    
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case presentHelperSheet
        case moveToNextButtonDidTap
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .presentHelperSheet:
                state.destination = .sheet(RegisterMedicationHelperReducer.State())
                return .none
            case .destination:
                return .none
            case .moveToNextButtonDidTap:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
}

extension RegisterNewMedicationReducer {
    @Reducer
    struct Destination {
        enum State: Equatable {
            case sheet(RegisterMedicationHelperReducer.State)
        }
        
        enum Action {
            case sheet(RegisterMedicationHelperReducer.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.sheet, action: \.sheet) {
                RegisterMedicationHelperReducer()
            }
        }
    }
}
