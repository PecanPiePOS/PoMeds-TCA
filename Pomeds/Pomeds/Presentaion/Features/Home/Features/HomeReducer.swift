//
//  HomeReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Foundation
import SwiftUI
import UIKit

import ComposableArchitecture

@Reducer
struct HomeReducer {
    typealias TakingMedication = MedicationRecordItem
    @Dependency(\.ongoingMedicationData) var medicationData
    
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var isTakingMeds: Bool = false
        var takingMedicationList: [TakingMedication] = []
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case popToRoot
        
        case fetchOngoingMedication
        case fetchedData(Result<[TakingMedication], Error>)
                
//        case registerNewMedicationDidTap
//        case registerCaptureDidTap
//        case registerSupplementsDidTap
//        case registerMedicinesCaptureFinishedDidTap
//        case registerDetailMedicationDidTap
        
//        case ongoingMedicationsDidTap
//        case ongoingDetailMedicationsDidTap
        
//        case pastMedicationsDidTap
//        case pastDetailMedicationsDidTap
        
//        case myPageDidTap
//        case sideEffectsWhenAvailableDidTap
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchOngoingMedication:
                state.isLoading = true
                return .run { send in
                    do {
                        let response = try await medicationData.fetch(isTaking: true)
                        await send(.fetchedData(.success(response)))
                    } catch let error {
                        await send(.fetchedData(.failure(error)))
                    }
                }
                
            case let .fetchedData(.success(medication)):
                state.isLoading = false
                state.takingMedicationList = medication
                return .none
                
            case .fetchedData(.failure):
                state.isLoading = false
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .registerNewMedication(.moveToNextButtonDidTap)):
                    state.path.append(.captureImageScene())
                    return .none
                case .element(id: _, action: .captureImage(.recognizeDidEnd(let data))):
                    state.path.append(.listOfRecognizedMedicinesScene(.init(dataPassed: data)))
                    return .none
                case .element(id: _, action: .listOfRecognizedMedicines(.nextButtonDidTap)):
                    state.path.append(.captureImageScene())
                    return .none
                case .element(id: _, action: .listOfRecognizedMedicines(.popToRootView)):
                    state.path.removeAll()
                    return .none
                case .element(id: _, action: .settingDetailOfMedication(.popToRootView)):
                    state.path.removeAll()
                    return .none
                default:
                    return .none
                }
                
            case .popToRoot:
                /// onAppear 에..? 일단 onAppear 에...
                state.path.removeAll()
                return .none
//            case .registerNewMedicationDidTap:
//                
//            case .ongoingMedicationsDidTap:
//                
//            case .pastMedicationDidTap:
//                
//            case .myPageDidTap:
//                
//            case .sideEffectsWhenAvailableDidTap:

            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
}

extension HomeReducer {
    
    @Reducer
    struct Path {
        enum State: Equatable {
            case registerNewMedicationScene(RegisterNewMedicationReducer.State = .init())
            case captureImageScene(CaptureMedicinesReducer.State = .init())
            case listOfRecognizedMedicinesScene(ListOfRecognizedMedicineReducer.State)
            case settingDetailOfMedicationScene(SettingDetailOfMedicationReducer.State)
            
//            case listOfOngoingMedicationScene()
//            case listOfPastMedicationScene()
//            case myPageScene()
//            case manageSideEffectsScene()
        }
        
        enum Action {
            case registerNewMedication(RegisterNewMedicationReducer.Action)
            case captureImage(CaptureMedicinesReducer.Action)
            case listOfRecognizedMedicines(ListOfRecognizedMedicineReducer.Action)
            case settingDetailOfMedication(SettingDetailOfMedicationReducer.Action)
//            case listOfOngoingMedication
//            case listOfPastMedication
//            case myPage
//            case manageSideEffects
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.registerNewMedicationScene, action: \.registerNewMedication) {
                RegisterNewMedicationReducer()
            }
            Scope(state: \.captureImageScene, action: \.captureImage) {
                CaptureMedicinesReducer()
            }
            Scope(state: \.listOfRecognizedMedicinesScene, action: \.listOfRecognizedMedicines) {
                ListOfRecognizedMedicineReducer()
            }
            Scope(state: \.settingDetailOfMedicationScene, action: \.settingDetailOfMedication) {
                SettingDetailOfMedicationReducer()
            }
//            Scope(state: \.listOfOngoingMedicationScene, action: \.listOfOngoingMedication) {
//                
//            }
//            Scope(state: \.listOfPastMedicationScene, action: \.listOfPastMedication) {
//                
//            }
//            Scope(state: \.myPageScene, action: \.myPage) {
//                
//            }
//            Scope(state: \.manageSideEffectsScene, action: \.manageSideEffects) {
//                
//            }
        }
    }
}



