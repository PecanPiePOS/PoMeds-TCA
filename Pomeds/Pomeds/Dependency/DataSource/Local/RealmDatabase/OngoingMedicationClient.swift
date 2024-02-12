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
    var fetch: () async throws -> [MedicationRecordItem]
}

extension OngoingMedicationClient: DependencyKey {
    static let liveValue = Self (
        fetch: { 
            var result: [MedicationRecordItem] = []
            try await MedicationRealmDataSource.list(request: true) { data in
                print(data, "📌")
                result = data
            }
            return result
        }
    )
}

extension DependencyValues {
    var ongoingMedicationData: OngoingMedicationClient {
        get { self[OngoingMedicationClient.self] }
        set { self[OngoingMedicationClient.self] = newValue }
    }
}
