//
//  VisionRecognitionClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import UIKit
import Foundation

import ComposableArchitecture

@DependencyClient
struct VisionRecognitionClient {
    var accept: (_ photoData: [Data]) async throws -> [String?]
}

extension VisionRecognitionClient: DependencyKey {
    static let liveValue = Self (
        accept: { images in
            return try await VisionRecognitionHelper.shared.getRecognizedText(with: images)
        }
    )
}

extension DependencyValues {
    var visionRecognizer: VisionRecognitionClient {
        get { self[VisionRecognitionClient.self] }
        set { self[VisionRecognitionClient.self] = newValue }
    }
}
