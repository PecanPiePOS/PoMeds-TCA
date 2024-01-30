//
//  OngoingMedicationRepository.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import SwiftData

struct OngoingMedicationRepository<DataSource: LocalDataSource>: Repository
where
DataSource.Response == MedicationRecordItem,
DataSource.Request == Bool {
    
    typealias Request = Bool
    typealias Response = [MedicationRecordItem]
    
    private let localDataSource: DataSource
    
    init(localDataSource: DataSource) {
        self.localDataSource = localDataSource
    }
    
    func execute(request: Bool?) async throws -> [MedicationRecordItem] {
        return try await localDataSource.list(request: true)
    }
}
