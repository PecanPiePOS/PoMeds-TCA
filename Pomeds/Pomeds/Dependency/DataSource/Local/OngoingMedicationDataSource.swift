//
//  OngoingMedicationDataSource.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

/**
 
 NOT BEING USE
 - Will Be Back
 
 */
struct OngoingMedicationDataSource {
    
    static let shared = OngoingMedicationDataSource()
    private let realm = try! Realm()
        
    func list(request: Bool) async throws -> [MedicationRecordItem] {
        var list: [MedicationRecordItem] = []
        realm.objects(MedicationRecordItem.self)
            .filter {$0.isTakingNow == request}
            .forEach {
            list.append($0)
        }
        return list
    }
    
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
    
    func delete(id: ObjectId) async throws -> Bool {
        let deletingItem = realm.objects(MedicationRecordItem.self).filter {$0._id == id}
        do {
            try realm.write {
                realm.delete(deletingItem)
            }
            return true
        } catch let error {
            print("Error deleting data: <\(error)>")
            return false
        }
    }
}
