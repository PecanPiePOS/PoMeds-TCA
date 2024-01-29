//
//  Interactor.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

struct Interactor<Request, Response, R: Repository>: UseCase
where R.Request == Request, R.Response == Response {
    
    private let repository: R
    
    init(repository: R) {
        self.repository = repository
    }
    
    func execute(request: Request) async throws -> Response {
        try await repository.execute(request: request)
    }
}
