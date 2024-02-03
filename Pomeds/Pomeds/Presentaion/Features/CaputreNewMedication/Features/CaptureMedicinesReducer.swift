//
//  CaptureMedicinesReducer.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Foundation
import UIKit

import ComposableArchitecture

struct MovingType: Equatable {
    var nameList: [String]
    var type: MedicationType
}

@Reducer
struct CaptureMedicinesReducer {
    typealias PillNames = [String?]
    typealias PhotoData = Data
    
    @Dependency(\.medicineSearchData) private var searchData
    @Dependency(\.visionRecognizer) private var visionRecognizer
    @Dependency(\.cropDataWhereNeeded) private var cropHelper
    @Dependency(\.continuousClock) private var clock
    
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        
        var capturedPhoto: UIImage?
        var caputredPhotoStack: [PhotoData] = []
        var photoCount: Int = 0
        
        var isCapturingProcessLoading = false
        var isRecognizingLoading = false
        var isCaptureEnabled = true
        
        var showPhotoStack = false
        var showMoveToNextButton = false
        var showRemoveLastPhotoButton = false
    }
    
    enum Action {
        case captureDidTap(PhotoData)
        case captureDisable
        case postProcessPhoto(PhotoData)
        case photoStackDidTap
        case buttonThrottle
        case removeLastPhotoDidTap
        
        case openAlert([String])
        case alert(PresentationAction<Alert>)
        
        case saveLastCapturedPhoto(UIImage)
        case photoRemoveLast
        
        case moveToNextDidTap
        case recognizeDidEnd(MovingType)
        case moveToSupplementsDidTap
        case resetLoading
        
        enum Alert: Equatable {
            case confirm([String])
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .captureDidTap(photoData):
                return .run { send in
                    let croppedData = try await self.cropHelper.cropData(originalData: photoData)
                    print(croppedData, "📌 captureDidTap")
                    await send(.postProcessPhoto(croppedData))
                }
                
            case .captureDisable:
                // 왜 바로 view 에서 반영이 안될까...
                state.isCaptureEnabled = false
                state.isCapturingProcessLoading = true
                return .none
                
            case let .postProcessPhoto(photoData):
                state.caputredPhotoStack.append(photoData)
                state.photoCount = state.caputredPhotoStack.count
                print(state.photoCount, "📌", "postProcessPhoto")
                return .run { send in
                    await send(.saveLastCapturedPhoto(UIImage(data: photoData) ?? UIImage()))
                    try await self.clock.sleep(for: .milliseconds(1500))
                    await send(.buttonThrottle)
                }
                
            case .removeLastPhotoDidTap:
                return .run { send in
                    await send(.photoRemoveLast)
                }
                
            case .buttonThrottle:
                state.isCapturingProcessLoading = false
                state.isCaptureEnabled = true
                return .none
                
            case .photoRemoveLast:
                var newStack = state.caputredPhotoStack
                _ = newStack.popLast()
                state.caputredPhotoStack = newStack
                state.photoCount = state.caputredPhotoStack.count
                if state.caputredPhotoStack.isEmpty {
                    state.capturedPhoto = nil
                }
                return .none
                
            case .moveToNextDidTap:
                state.isRecognizingLoading = true
                return .run { [stack = state.caputredPhotoStack] send in
                    if stack.isEmpty {
                        await send(.recognizeDidEnd(MovingType(nameList: [], type: .medication)))
                        return
                    }
                    let namesRecognizedData = try await visionRecognizer.accept(stack)
                    let compactList = namesRecognizedData.compactMap({ $0 })
                    if compactList.count != stack.count {
                        await send(.openAlert(compactList))
                    } else {
                        await send(.recognizeDidEnd(MovingType(nameList: compactList, type: .medication)))
                    }
                }
                
            case .photoStackDidTap:
                return .none

            case let .saveLastCapturedPhoto(capturedImage):
                state.capturedPhoto = capturedImage
                return .none
                
            case .recognizeDidEnd:
                state.isRecognizingLoading = false
                return .none
                
            case .moveToSupplementsDidTap:
                return .run { send in
                    await send(.recognizeDidEnd(MovingType(nameList: [], type: .supplements)))
                }
                
            case let .alert(.presented(.confirm(names))):
                return .run { send in
                    await send(.recognizeDidEnd(MovingType(nameList: names, type: .medication)))
                }
                
            case let .openAlert(names):
                state.alert = AlertState {
                    TextState("인식에 실패한 사진이 있어요")
                } actions: {
                    ButtonState(
                        action: .send(.confirm(names))
                    ) {
                        TextState("확인")
                    }
                } message: {
                    TextState("추가하고 싶은 약이 있다면 직접 추가해주세요")
                }
                return .none
                
            case .alert:
                return .none

            case .resetLoading:
                state.isRecognizingLoading = false
                return .none
            }
        }
    }
}
