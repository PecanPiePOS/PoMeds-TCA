//
//  ListOfRecognizedMedicineReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/1/24.
//

import Foundation

import ComposableArchitecture

struct RecognizedMedicationModel: Equatable, Identifiable {
    let id: UUID
    var medicineName: String
}

@Reducer
struct ListOfRecognizedMedicineReducer {
    
    @Dependency(\.uuid) private var uuid
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var dataPassed: RecognizedMedicationTransferModel
        
        var titleText: String = ""
        var recognizedList: IdentifiedArrayOf<RecognizedMedicationModel> = []
        var medicationType: MedicationType = .medication
        var listCount: Int = 0
        var editingTitle: String = ""
        var editingId: UUID?
    }
    
    enum Action {
        case onAppear
        
        // 여기서는 굳이 TCA 의 Alert 를 쓸 필요가 없을듯
        // 커스텀한 곳에서 이벤트 받아서 처리하면 되잖아 그치?
        case addingNewMedicineDidEndEditing(String)
        case editMedicineDidTap(String, RecognizedMedicationModel.ID)
        case cancelEditing
        case editingMedicineDidEndEditing(String)
        case removeDidTap(IndexSet)
        case exitDidTap
        case syncDataWhenCompleteDidTap(RecognizedMedicationTransferModel)
        
        case resetData
        case popToRootView
        
        case completeEditing
        case nextButtonDidTap(RecognizedMedicationTransferModel)
        case alert(PresentationAction<Alert>)
        
        enum Alert: Equatable {
            case popToRoot
            case cancel
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.titleText = state.dataPassed.type.titleText
                state.medicationType = state.dataPassed.type
                state.recognizedList = []
                for item in state.dataPassed.nameList {
                    let modifiedName = item.replacingOccurrences(of: "\n", with: "")
                    if !modifiedName.isEmpty {
                        state.recognizedList.append(.init(id: self.uuid(), medicineName: modifiedName))
                    }
                }
                return .none
                
            case .completeEditing:
                return .run { [list = state.recognizedList, type = state.medicationType] send in
                    var arrayOfNameList: [String] = []
                    for item in list {
                        arrayOfNameList.append(item.medicineName)
                    }
                    await send(.nextButtonDidTap(.init(nameList: arrayOfNameList, type: type)))
                    await send(.syncDataWhenCompleteDidTap(.init(nameList: arrayOfNameList, type: type)))
                }
                
            case let .syncDataWhenCompleteDidTap(editedData):
                state.dataPassed = editedData
                return .none
                
            case .nextButtonDidTap:
                return .none
                
            case let .addingNewMedicineDidEndEditing(newMedicine):
                state.recognizedList.append(.init(id: self.uuid(), medicineName: newMedicine))
                return .none
                
            case let .editMedicineDidTap(originalMedicine, id):
                state.editingTitle = originalMedicine
                state.editingId = id
                return .none
                
            case .cancelEditing:
                return .run { send in
                    await send(.resetData)
                }
                
            case let .editingMedicineDidEndEditing(editedMedicine):
                state.recognizedList[id: state.editingId ?? self.uuid()]?.medicineName = editedMedicine
                return .run { send in
                    await send(.resetData)
                }
                
            case let .removeDidTap(indexSet):
                state.recognizedList.remove(atOffsets: indexSet)
                return .none
                
            case .resetData:
                state.editingId = nil
                state.editingTitle = ""
                return .none
                
            case .exitDidTap:
                state.alert = AlertState {
                    TextState("새로운 복용 추가를 그만 두시겠습니까?")
                } actions: {
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
                
            case .popToRootView:
                return .none
                
            case .alert(.presented(.cancel)):
                return .none
                
            case .alert(.presented(.popToRoot)):
                return .run { send in
                    await send(.popToRootView)
                }
                
            case .alert:
                return .none
            }
        }
    }
}
