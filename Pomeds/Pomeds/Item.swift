//
//  Item.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/24/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
