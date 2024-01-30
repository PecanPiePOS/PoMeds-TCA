//
//  MedicationIntakeInfo.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

struct MedicationIntakeInfo {
    var reasonForTaking: String
    var startDate: Date
    var endDate: Date
    var intervalOfTaking: Int
    var startTimeOfDay: Int
    var isTakingMorningMedication: Bool
}

final class MedicationIntakeInfoItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var reasonForTaking: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var intervalOfTaking: Int
    @Persisted var startTimeOfDay: Int
    @Persisted var isTakingMorningMedication: Bool
    
    convenience init(reasonForTaking: String, startDate: Date, endDate: Date, intervalOfTaking: Int, startTimeOfDay: Int, isTakingMorningMedication: Bool) {
        self.init()
        
        self.reasonForTaking = reasonForTaking
        self.startDate = startDate
        self.endDate = endDate
        self.intervalOfTaking = intervalOfTaking
        self.startTimeOfDay = startTimeOfDay
        self.isTakingMorningMedication = isTakingMorningMedication
    }
}
