//
//  PomedsTests.swift
//  PomedsTests
//
//  Created by KYUBO A. SHIM on 1/24/24.
//

import XCTest

import ComposableArchitecture
@testable import Pomeds

@MainActor
final class PomedsTests: XCTestCase {

    func testDelegate_NonExhaustive() async {
        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
                ._printChanges()
        }
    }

}
