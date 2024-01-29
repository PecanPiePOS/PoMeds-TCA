//
//  PushNotificationInfo.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation
import SwiftData

/**
 푸시에 들어갈 타이틀과 바디입니다.
 */
struct PushNotificationInfo {
    var title: String
    var sequenceOfMedicationBody: String
}

@Model
final class PushNotificationInfoItem {
    var title: String
    var sequenceOfMedicationBody: String
    
    init(title: String, sequenceOfMedicationBody: String) {
        self.title = title
        self.sequenceOfMedicationBody = sequenceOfMedicationBody
    }
}
