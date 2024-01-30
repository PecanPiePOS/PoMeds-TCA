//
//  HomeReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Foundation

import ComposableArchitecture

typealias MedicationRecordInteractor = Interactor<
    Bool,
    [MedicationRecordItem],
    OngoingMedicationRepository<
        OngoingMedicationDataSource
    >
>

@Reducer
struct HomeReducer {
    
    typealias TakingMedication = MedicationRecordItem
    
    private let useCase: MedicationRecordInteractor
    
    init(useCase: MedicationRecordInteractor) {
        self.useCase = useCase
    }
    
    struct State: Equatable {
        var isLoading: Bool = false
        var isTakingMeds: Bool = false
        var takingMedicationList: [TakingMedication] = []
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case fetchOngoingMedication
        case fetchedData(Result<[TakingMedication], Error>)
        case path(StackAction<Path.State, Path.Action>)
        case popToRoot
//        case registerNewMedicationDidTap
//        case ongoingMedicationsDidTap
//        case pastMedicationDidTap
//        case myPageDidTap
//        case sideEffectsWhenAvailableDidTap
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchOngoingMedication:
                state.isLoading = true
                return .run { send in
                    do {
                        let response = try await self.useCase.execute(request: true)
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
                case .element(id: _, action: .registerNewMedication):
                    state.path.append(.registerNewMedicationScene)
                    return .none
                case .element(id: _, action: .listOfOngoingMedication):
                    state.path.append(.listOfOngoingMedicationScene)
                    return .none
                case .element(id: _, action: .listOfPastMedication):
                    state.path.append(.listOfPastMedicationScene)
                    return .none
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
//                
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
        enum State: Codable, Equatable, Hashable {
            /// 이곳에 각 화면의 Reducer 가 들어감
            /// ex) case registerNewMedicationScene(NewMedication.State = .init())
            case registerNewMedicationScene
            case listOfOngoingMedicationScene
            case listOfPastMedicationScene
            case myPageScene
        }
        
        enum Action {
            case registerNewMedication
            case listOfOngoingMedication
            case listOfPastMedication
            case myPageScene
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.registerNewMedicationScene, action: \.registerNewMedication) {
                // 여기에 Reducer()
            }
        }
    }
}
