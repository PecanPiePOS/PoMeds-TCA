//
//  MedicineSearchClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Foundation

import ComposableArchitecture

@DependencyClient
struct MedicineSearchClient {
    var fetch: (_ medicineName: String) async throws -> [MedicationResponse]
}

extension MedicineSearchClient {
    
}
