//
//  OngoingMedicationDataSource.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

/**
 https://github.com/realm/realm-swift/discussions/7685
 */
struct MedicationRealmDataSource {

    static let shared = MedicationRealmDataSource()
    private init() {}
        
    static func list(request: Bool, completion: @escaping ([MedicationRecordItem]) -> Void) async throws {
        DispatchQueue.main.async {
            let realm = try! Realm()
            var list: [MedicationRecordItem] = []
            realm.objects(MedicationRecordItem.self)
                .filter {$0.isTakingNow == request}
                .forEach {
                list.append($0)
            }
            print(list, "📌📌📌")
            completion(list)
        }
    }
    
    static func add(entity: MedicationRecordItem) async throws -> Bool {
        
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
    
    static func delete(id: ObjectId) async throws -> Bool {
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





/**
 https://github.com/realm/realm-swift/discussions/7685

struct MedicationRealmDataSource {
    
    static let shared = MedicationRealmDataSource()
    private init() {}
    
    let realm = try! Realm()
        
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
*/
