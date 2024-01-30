//
//  LocalDataSource.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

protocol LocalDataSource {
    associatedtype Request
    associatedtype Response
    
    func list(request: Bool) async throws -> [Response]
    func add(entity: Response) async throws -> Bool
    func delete(id: ObjectId) async throws -> Bool
}
