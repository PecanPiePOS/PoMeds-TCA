//
//  MedicineSearchClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Combine
import Foundation

import ComposableArchitecture

@DependencyClient
struct MedicineSearchClient {
    var fetch: (_ medicineName: String) async throws -> AnyPublisher<MedicationResponse, APIError>
}

extension MedicineSearchClient: DependencyKey {
    static let liveValue = Self (
        fetch: { medicineName in
            return try await MedicineSearchService.shared.getMedicine(requset: medicineName)
        }
    )
}

extension DependencyValues {
    var medicineSearchData: MedicineSearchClient {
        get { self[MedicineSearchClient.self] }
        set { self[MedicineSearchClient.self] = newValue }
    }
}
