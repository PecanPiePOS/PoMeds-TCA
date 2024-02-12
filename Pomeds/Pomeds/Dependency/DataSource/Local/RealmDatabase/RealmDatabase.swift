//
//  RealmDatabase.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/12/24.
//

import Foundation

import RealmSwift

final class RealmService {
    func fetchOngoingList() async throws -> [MedicationRecord] {
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let now = Date()
                    print("📌 \(#function) fetch ongoing Realm Thread of...: ", Thread.current)
                    let results = Array(realm.objects(MedicationRecordItem.self))
                    let items = results
                        .filter { $0.endDate > now }
                        .filter { now > $0.startDate }
                        .map { MedicationRecord(from: $0) }
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetchPastList() async throws -> [MedicationRecord] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let now = Date()
                    let results = Array(realm.objects(MedicationRecordItem.self))
                        
                    let items = results
                        .filter { $0.endDate < now }
                        .map { MedicationRecord(from: $0) }
                    continuation.resume(returning: items)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchObjectWithId(id: ObjectId) async throws -> MedicationRecord? {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    let object = realm.objects(MedicationRecordItem.self)
                        .filter { $0._id == id }
                        .first
                        .map { MedicationRecord(from: $0) }
                    continuation.resume(returning: object)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func save(object: MedicationRecordItem) async throws -> Bool {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(object)
                    }
                    continuation.resume(returning: true)
                } catch {
                    print("Error saving object: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    func delete(id: ObjectId) async throws -> Bool {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                do {
                    let realm = try Realm()
                    guard let objectToDelete = realm.objects(MedicationRecordItem.self)
                        .filter({ $0._id == id }).first
                    else {
                        print("Object not found for deletion.")
                        continuation.resume(returning: false)
                        return
                    }
                    try realm.write {
                        realm.delete(objectToDelete)
                    }
                    continuation.resume(returning: true)
                } catch {
                    print("Error deleting object: \(error)")
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
}

/*
 
 
 private func getRealmInstance() async throws -> Realm {
     return try await Realm()
 }
 
 private func executeOnMainThread<T>(_ operation: @escaping () async throws -> T) async throws -> T {
     return try await withCheckedThrowingContinuation { continuation in
         DispatchQueue.main.async {
             Task {
                 do {
                     let result = try await operation()
                     continuation.resume(returning: result)
                 } catch {
                     continuation.resume(throwing: error)
                 }
             }
         }
     }
 }

 func fetchOngoingList() async throws -> [MedicationRecordItem] {
     try await executeOnMainThread {
         let now = Date()
         let realm = try await self.getRealmInstance()
         print("📌 RealmService fetch ongoing:", Thread.current)
         return Array(realm.objects(MedicationRecordItem.self))
//                .filter("endDate > %@", now)
//                .filter("startDate < %@", now))
     }
 }
 
 func fetchPastList() async throws -> [MedicationRecordItem] {
     try await executeOnMainThread {
         let now = Date()
         let realm = try await self.getRealmInstance()
         return Array(realm.objects(MedicationRecordItem.self)
             .filter("endDate < %@", now))
     }
 }

 func fetchObjectWithId(id: ObjectId) async throws -> MedicationRecordItem? {
     try await executeOnMainThread {
         let realm = try await self.getRealmInstance()
         return realm.object(ofType: MedicationRecordItem.self, forPrimaryKey: id)
     }
 }

 func save<T: Object>(object: T) async throws -> Bool {

     try await executeOnMainThread {
         do {
             let realm = try await self.getRealmInstance()
             try realm.write {
                 realm.add(object)
             }
             return true
         } catch {
             return false
         }
     }
 }

 func delete(id: ObjectId) async throws -> Bool {
     try await executeOnMainThread {
         do {
             let realm = try await self.getRealmInstance()
             guard let deletingObject = realm.object(ofType: MedicationRecordItem.self, forPrimaryKey: id) else {
                 throw NSError(domain: "com.example.RealmService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found for deletion."])
             }
             try realm.write {
                 realm.delete(deletingObject)
             }
             return true
         } catch {
             return false
         }
     }
 }
 
 
 */
