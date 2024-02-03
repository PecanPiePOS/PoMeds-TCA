//
//  OngoingMedicationDataSource.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

struct MedicationRealmDataSource {
    
    static let shared = MedicationRealmDataSource()
    private init() {}
        
    @MainActor
    func list(request: Bool) async throws -> [MedicationRecordItem] {
        let realm = try! await Realm()
        var list: [MedicationRecordItem] = []
        realm.objects(MedicationRecordItem.self)
            .filter {$0.isTakingNow == request}
            .forEach {
            list.append($0)
        }
        return list
    }
    
    @MainActor
    func add(entity: MedicationRecordItem) async throws -> Bool {
        let realm = try! await Realm()
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
    
    @MainActor
    func delete(id: ObjectId) async throws -> Bool {
        let realm = try! await Realm()
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
