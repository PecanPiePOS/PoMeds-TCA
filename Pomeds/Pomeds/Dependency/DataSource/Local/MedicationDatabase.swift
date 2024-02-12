//
//  MedicationDatabase.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/8/24.
//

import Combine
import Foundation

import ComposableArchitecture
import RealmSwift

@DependencyClient
struct MedicationDatabaseClient {
    var fetchOngoingMedications: () async throws -> [MedicationRecord]
    var fetchPastMedications: () async throws -> [MedicationRecord]
    var fetchObjectWithId: (ObjectId) async throws -> MedicationRecord?
    var save: (_ medication: MedicationRecordItem) async throws -> Bool
    var delete: (_ id: ObjectId) async throws -> Bool
}

extension MedicationDatabaseClient: DependencyKey {
    static let realm = RealmService()

    static let liveValue: MedicationDatabaseClient = Self(
        fetchOngoingMedications: {
            return try await realm.fetchOngoingList()
        }, fetchPastMedications: {
            return try await realm.fetchPastList()
        }, fetchObjectWithId: {
            try await realm.fetchObjectWithId(id: $0)
        }, save: {
            try await realm.save(object: $0)
        }, delete: {
            try await realm.delete(id: $0)
        }
    )
}

extension DependencyValues {
    var medicationDatabase: MedicationDatabaseClient {
        get { self[MedicationDatabaseClient.self] }
        set { self[MedicationDatabaseClient.self] = newValue }
    }
}
