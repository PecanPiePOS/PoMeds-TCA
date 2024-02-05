//
//  PomedsApp.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/24/24.
//

import SwiftUI

import ComposableArchitecture

@main
struct PomedsApp: App {
    static let store = Store(initialState: HomeReducer.State()) {
        HomeReducer()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(store: PomedsApp.store)
        }
    }
}
