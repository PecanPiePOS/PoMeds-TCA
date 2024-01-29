//
//  UseCase.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

protocol UseCase {
    associatedtype Request
    associatedtype Response
    
    func execute(request: Request) async throws -> Response
}