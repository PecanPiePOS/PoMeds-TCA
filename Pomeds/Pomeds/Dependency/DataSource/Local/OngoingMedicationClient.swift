//
//  OngoingMedicationClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/30/24.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct OngoingMedicationClient {
    var fetch: (_ isTaking: Bool) async throws -> [MedicationRecordItem]
}

extension OngoingMedicationClient: DependencyKey {
    static let liveValue = Self (
        fetch: { isTaking in
            return try await OngoingMedicationDataSource.shared.list(request: true)
        }
    )
}

extension DependencyValues {
    var ongoingMedicationData: OngoingMedicationClient {
        get { self[OngoingMedicationClient.self] }
        set { self[OngoingMedicationClient.self] = newValue }
    }
}
