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
import RealmSwift

@Reducer
struct HomeReducer {
    typealias TakingMedication = MedicationRecordItem
    @Dependency(\.ongoingMedicationData) var medicationData
    @Dependency(\.continuousClock) var clock
    
    private(set) var localRealm: Realm?
    
    init() {
        openRealm()
    }
    
    @ObservableState
    struct State: Equatable {
        var isLoading: Bool = false
        var isTakingMeds: Bool = false
        var takingMedicationList: [TakingMedication] = []
        var hasSucceededRegisteringNewMeds: Bool = false
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case popToRoot
        
        case onAppear
        case fetchOngoingMedication
        case fetchedData(Result<[TakingMedication], Error>)
        case showNewRegisterSuccessToast
        case hideNewRegisterSuccessToast
        
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
            case .onAppear:
                state.isLoading = true
                state.takingMedicationList = fetchOngoingMedications()
                state.isLoading = false
                return .none
                
            case .fetchOngoingMedication:
                return .run { send in
                    do {
                        let response = try await medicationData.fetch()
                        await send(.fetchedData(.success(response)))
                    } catch let error {
                        await send(.fetchedData(.failure(error)))
                    }
                }

            case .showNewRegisterSuccessToast:
                state.hasSucceededRegisteringNewMeds = true
                return .run { send in
                    try await self.clock.sleep(for: .seconds(1))
                    await send(.hideNewRegisterSuccessToast)
                }
                
            case .hideNewRegisterSuccessToast:
                state.hasSucceededRegisteringNewMeds = false
                return .none
                
            case let .fetchedData(.success(medication)):
                state.isLoading = false
                state.takingMedicationList = medication
                return .none
                
            case .fetchedData(.failure):
                state.isLoading = false
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action:
                    .registerNewMedication(.moveToNextButtonDidTap)):
                    /// 여기 참고해서!
                    state.path.append(.captureImageScene())
                    return .none
                case .element(id: _, action: .captureImage(.recognizeDidEnd(let data))):
                    state.path.append(.listOfRecognizedMedicinesScene(.init(dataPassed: data)))
                    return .none
                case .element(id: _, action: .listOfRecognizedMedicines(.nextButtonDidTap(let data))):
                    state.path.append(.settingDetailOfMedicationScene(.init(listOfMedicinesPassed: data.nameList, medicineType: data.type)))
                    return .none
                case .element(id: _, action: .listOfRecognizedMedicines(.popToRootView)):
                    state.path.removeAll()
                    return .none
                case .element(id: _, action: .listOfOngoingMedication(.cellDidTapWith(let id, let title))):
                    state.path.append(.detailOfOngoingMedicationScene(.init(medicationTitle: title, isOngoing: true, id: id)))
                    return .none
                case .element(id: _, action: .listOfPastMedication(.cellDidTapWith(let id, let title))):
                    state.path.append(.detailOfPastMedicationScene(.init(medicationTitle: title, isOngoing: false, id: id)))
                    return .none
                case .element(id: _, action: .settingDetailOfMedication(.popToRootViewWith(let newMedication))):
                    let success = registerNewMedicine(newMedication: newMedication)
                    switch success {
                    case true:
                        state.path.removeAll()
                        return .run { send in
                            try await self.clock.sleep(for: .seconds(1))
                            await send(.showNewRegisterSuccessToast)
                        }
                    case false:
                        return .none
                    }
                default:
                    return .none
                }
                
            case .popToRoot:
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
    
    mutating
    func openRealm() {
        do {
            let configuration = Realm.Configuration(schemaVersion: UInt64(ServiceKey.realmSchemaVersion))
            Realm.Configuration.defaultConfiguration = configuration
            self.localRealm = try Realm()
        } catch {
            print("Error opening Realm : \(error)")
        }
    }
    
    private func fetchOngoingMedications() -> [MedicationRecordItem] {
        if let localRealm {
            let now = Date()
            
            let incomingMedicationsList = localRealm
                .objects(MedicationRecordItem.self)
                .filter { $0.endDate > now }
            let ongoingMedications = incomingMedicationsList
                .filter { now > $0.startDate }
            
            print("📌realm", ongoingMedications)
            return Array(ongoingMedications)
        } else {
            return []
        }
    }
    
    private func registerNewMedicine(newMedication: MedicationRecordItem) -> Bool {
        if let localRealm {
            do {
                try localRealm.write {
                    localRealm.add(newMedication)
                }
                return true
            } catch let error  {
                print("Error adding data: <\(error)>")
                return false
            }
        } else {
            return false
        }
    }
}

extension HomeReducer {
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable {
            case registerNewMedicationScene(RegisterNewMedicationReducer.State = .init())
            case captureImageScene(CaptureMedicinesReducer.State = .init())
            case listOfRecognizedMedicinesScene(ListOfRecognizedMedicineReducer.State)
            case settingDetailOfMedicationScene(SettingDetailOfMedicationReducer.State)
            case listOfOngoingMedicationScene(ListOfOngoingMedicationsReducer.State = .init())
            case listOfPastMedicationScene(ListOfPastMedicationsReducer.State = .init())
            case detailOfOngoingMedicationScene(CommonDetailListReducer.State)
            case detailOfPastMedicationScene(CommonDetailListReducer.State)
            
//            case myPageScene()
//            case manageSideEffectsScene()
        }
        
        enum Action {
            case registerNewMedication(RegisterNewMedicationReducer.Action)
            case captureImage(CaptureMedicinesReducer.Action)
            case listOfRecognizedMedicines(ListOfRecognizedMedicineReducer.Action)
            case settingDetailOfMedication(SettingDetailOfMedicationReducer.Action)
            case listOfOngoingMedication(ListOfOngoingMedicationsReducer.Action)
            case listOfPastMedication(ListOfPastMedicationsReducer.Action)
            case detailOfOngoingMedication(CommonDetailListReducer.Action)
            case detailOfPastMedication(CommonDetailListReducer.Action)
            
            
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
            Scope(state: \.listOfOngoingMedicationScene, action: \.listOfOngoingMedication) {
                ListOfOngoingMedicationsReducer()
            }
            Scope(state: \.listOfPastMedicationScene, action: \.listOfPastMedication) {
                ListOfPastMedicationsReducer()
            }
            Scope(state: \.detailOfOngoingMedicationScene, action: \.detailOfOngoingMedication) {
                CommonDetailListReducer()
            }
            Scope(state: \.detailOfPastMedicationScene, action: \.detailOfPastMedication) {
                CommonDetailListReducer()
            }
        }
    }
}



