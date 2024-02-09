//
//  SettingDetailOfMedicationReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/1/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

@Reducer
struct SettingDetailOfMedicationReducer {
    @Dependency(\.continuousClock) var clock
    @Dependency(\.saveMedicationData) var saveData
    
    @ObservableState
    struct State: Equatable {

        let listOfMedicinesPassed: [String]
        var medicineType: MedicationType
        var listOfNames: [String] = []
        
        var medicationTitle: String = ""
        var medicineTypeTitle: String = ""
        var startDate: Date?
        var endDate: Date?
        var numberOfTakingPerDay: Int?
        var medicationIntervalTime: Int?
        var startTimeOfTaking: Date?
        
        var isAlarmEnabled = true
        var isLoading = false
        var isErrorHappened = false
    }
    
    enum Action {
        case onAppear
        case medicationTitleDidEndEditing(String)
        case medicationTypeDidSelected(MedicationType)
        case startDateDidAdd(Date)
        case endDateDidAdd(Date)
        case numberOfTakingPerDayDidAdd(Int)
        case medicationIntervalTimeDidAdd(Int)
        case startTimeOfTakingDidAdd(Date)
        case alarmEnabled(Bool)
        case completeButtonDidTap
//        case saveCompleted
        
        case errorPop
        case resetError
        case popToRootViewWith(MedicationRecordItem)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.medicineTypeTitle = state.medicineType.componentText
                state.listOfMedicinesPassed.forEach {
                    state.listOfNames.append($0)
                }
                return .none
                
            case let .medicationTypeDidSelected(type):
                state.medicineTypeTitle = type.componentText
                state.medicineType = type
                return .none
                
            case let .medicationTitleDidEndEditing(title):
                state.medicationTitle = title
                return .none
                
            case let .startDateDidAdd(startDate):
                state.startDate = startDate
                return .none
                
            case let .endDateDidAdd(endDate):
                state.endDate = endDate
                return .none
                
            case let .numberOfTakingPerDayDidAdd(count):
                state.numberOfTakingPerDay = count
                return .none
            case let .medicationIntervalTimeDidAdd(interval):
                state.medicationIntervalTime = interval
                return .none
                
            case let .startTimeOfTakingDidAdd(startTime):
                state.startTimeOfTaking = startTime
                return .none
                
            case let .alarmEnabled(isEnabled):
                state.isAlarmEnabled = isEnabled
                return .none
                
            case .completeButtonDidTap:
                state.isLoading = true
                return .run { [state] send in
                    if state.medicationTitle.isEmpty {
                        await send(.errorPop)
                        return
                    }
                    
                    guard let startDate = state.startDate,
                          let endDate = state.endDate,
                          let numberOfTakingPerDay = state.numberOfTakingPerDay,
                          let medicationIntervalTime = state.medicationIntervalTime,
                          let startTimeOfTaking = state.startTimeOfTaking
                    else {
                        await send(.errorPop)
                        return
                    }
                    
                    
                    let listOfPills = List<String>()
                    var isTakingNow: Bool
                    let now = Date().addingTimeInterval(3600)
                    if now > startDate && endDate > now {
                        isTakingNow = true
                    } else {
                        isTakingNow = false
                    }
                    
                    for item in state.listOfNames {
                        listOfPills.append(item)
                    }
                    
                    let newMedicineModelToSave = MedicationRecordItem(isTakingNow: isTakingNow, reasonForMedication: state.medicationTitle, startDate: startDate, endDate: endDate, pillNames: listOfPills, efficacy: "", sideEffects: List<String>(), medicationType: state.medicineType.stringRequest, numberOfTakingPerDay: numberOfTakingPerDay, intervalOfTaking: medicationIntervalTime, startTimeOfDay: startTimeOfTaking)
                    
                    await send(.popToRootViewWith(newMedicineModelToSave))
                    // TODO: Realm 쓰레드 문제가 해결되면 이런 UX 를 위한 코드 수정하거나 삭제하기
                    try await self.clock.sleep(for: .seconds(3))
                    await send(.errorPop)
                }
                
            case .errorPop:
                state.isErrorHappened = true
                state.isLoading = false
                return .run { send in
                    try await self.clock.sleep(for: .seconds(2))
                    await send(.resetError)
                }
                
            case .resetError:
                state.isErrorHappened = false
                return .none

            case .popToRootViewWith:
                return .none
            }
        }
    }
}
