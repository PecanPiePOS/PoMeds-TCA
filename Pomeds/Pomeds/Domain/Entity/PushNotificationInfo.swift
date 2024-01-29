//
//  PushNotificationInfo.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

/**
 푸시에 들어갈 타이틀과 바디입니다.
 */
struct PushNotificationInfo {
    var title: String
    var sequenceOfMedicationBody: String
}

final class PushNotificationInfoItem: Object {
    @Persisted var _id: ObjectId
    @Persisted var title: String
    @Persisted var sequenceOfMedicationBody: String
    
    convenience init(title: String, sequenceOfMedicationBody: String) {
        self.init()
        
        self.title = title
        self.sequenceOfMedicationBody = sequenceOfMedicationBody
    }
}
