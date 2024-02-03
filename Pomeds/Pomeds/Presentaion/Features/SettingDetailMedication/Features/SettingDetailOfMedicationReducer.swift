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
    
    // 여기에 save 해야 하는 거 추가 Dependency
//    @Dependency(\.)
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?

        let listOfMedicinesPassed: [String]/*IdentifiedArrayOf<RecognizedMedicationModel>*/
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
        case startDateDidAdd(Date)
        case endDateDidAdd(Date)
        case numberOfTakingPerDayDidAdd(Int)
        case medicationIntervalTimeDidAdd(Int)
        case startTimeOfTakingDidAdd(Date)
        case alarmEnabled(Bool)
        case completeButtonDidTap
        case saveCompleted
        
        case exitDidTap
        case alert(PresentationAction<Alert>)
        case errorPop
        case popToRootView
        
        enum Alert: Equatable {
            case popToRoot
            case cancel
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.medicineTypeTitle = state.medicineType.componentText
                state.listOfMedicinesPassed.forEach {
                    state.listOfNames.append($0)
                }
                print(state.listOfNames, "📌 PPAASSSSSSED!! TO SETTING!!")
                return .none
                
            case .exitDidTap:
                state.alert = AlertState {
                    TextState("새로운 복용 추가를 그만 두시겠습니까?")
                } actions: {
                    ButtonState(
                        action: .send(.cancel)
                    ) {
                        TextState("취소")
                    }
                    ButtonState(
                        role: .destructive,
                        action: .send(.popToRoot)
                    ) {
                        TextState("확인")
                    }
                } message: {
                    TextState("저장된 모든 정보가 사라져요")
                }
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
                    guard let startDate = state.startDate,
                          let endDate = state.endDate,
                          let numberOfTakingPerDay = state.numberOfTakingPerDay,
                          let medicationIntervalTime = state.medicationIntervalTime,
                          let startTimeOfTaking = state.startTimeOfTaking
                    else {
                        await send(.errorPop)
                        return
                    }
                    
                    let newMedicineModelToSave = MedicationRecord(isTakingNow: true, reasonForMedication: state.medicationTitle, startDate: startDate, endDate: endDate, pillNames: state.listOfNames, efficacy: "", sideEffects: [], medicationType: state.medicineTypeTitle)
//                    여기에 await dependeny 로 저장시키고 savecomplete 로 보내
                }
            case .saveCompleted:
                return .run { send in
                    await send(.popToRootView)
                }
                
            case .alert(.presented(.popToRoot)):
                return .run { send in
                    await send(.popToRootView)
                }
                
            case .alert(.presented(.cancel)):
                return .none
                
            case .alert:
                return .none
                
            case .errorPop:
                state.alert = AlertState {
                    TextState("에러가 발생했어요. 다시 시도해주세요.")
                } actions: {
                    ButtonState(
                        action: .send(.cancel)
                    ) {
                        TextState("확인")
                    }
                }
                return .none
                
            case .popToRootView:
                return .none
            }
        }
    }
}
