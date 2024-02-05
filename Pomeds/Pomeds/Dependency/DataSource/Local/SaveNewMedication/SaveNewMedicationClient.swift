//
//  SaveNewMedicationClient.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/5/24.
//

import Foundation

import ComposableArchitecture
import RealmSwift

@DependencyClient
struct SaveNewMedicationClient {
    var save: (MedicationRecordItem) async throws -> Bool
}

extension SaveNewMedicationClient: DependencyKey {
    static let liveValue = Self (
        save: {
            return try await SaveNewMedicationDataSource.shared.add(entity: $0)
        }
    )
}

extension DependencyValues {
    var saveMedicationData: SaveNewMedicationClient {
        get { self[SaveNewMedicationClient.self] }
        set { self[SaveNewMedicationClient.self] = newValue }
    }
}


struct SaveNewMedicationDataSource {
    
    static let shared = SaveNewMedicationDataSource()
    private init() {}
    
    let realm = try! Realm()
    
    func add(entity: MedicationRecordItem) async throws -> Bool {
        do {
            try realm.write {
                realm.add(entity)
            }
            return true
        } catch let error {
            print("Error adding data: <\(error)>")
            return false
        }
    }
}
