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
    var fetchOngoingMeications: () async throws -> [MedicationRecordItem]
    var fetchPastMedications: () async throws -> [MedicationRecordItem]
    var save: (_ medication: MedicationRecordItem) async throws -> Bool
    var delete: (_ id: ObjectId) async throws -> Bool
}

extension MedicationDatabaseClient: DependencyKey {
    static var liveValue: MedicationDatabaseClient = .init(fetchOngoingMeications: {
        let now = Date()
        return try Realm()
            .objects(MedicationRecordItem.self)
            .filter { $0.endDate > now }
            .filter { now > $0.startDate }
    }, fetchPastMedications: {
        let now = Date()
        return try Realm()
            .objects(MedicationRecordItem.self)
            .filter { $0.endDate < now }
    }, save: { medication in
        do {
        try Realm().write {
        try Realm().add(medication)
    }
        return true
    } catch {
        print("Error saving to Realm")
        return false
    }
    }, delete: { id in
        do {
        try Realm()
            .objects(MedicationRecordItem.self)
            .filter { $0._id == id }
            .forEach { result in
                try Realm().write {
        try Realm().delete(result)
    }
            }
        return true
    } catch {
        print("Error deleting from Realm")
        return false
    }
    })
}

extension DependencyValues {
    var medicationDatabase: MedicationDatabaseClient {
        get { self[MedicationDatabaseClient.self] }
        set { self[MedicationDatabaseClient.self] = newValue }
    }
}
