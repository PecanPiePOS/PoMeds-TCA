//
//  PhotoPostProcessClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/4/24.
//

import Foundation
import UIKit
import SwiftUI

import ComposableArchitecture

@DependencyClient
struct PhotoPostProcessClient {
    var cropData: (_ originalData: Data) async throws -> Data
}

extension PhotoPostProcessClient: DependencyKey {
    static let liveValue = Self (
        cropData: { data in
            return try await PhotoPostProcessHelper.cropDataInTheMiddle(of: data)
        }
    )
}

extension DependencyValues {
    var cropDataWhereNeeded: PhotoPostProcessClient {
        get { self[PhotoPostProcessClient.self] }
        set { self[PhotoPostProcessClient.self] = newValue }
    }
}
