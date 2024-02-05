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
    var numberOfTakingPerDay: Int
    var intervalOfTaking: Int
    var startTimeOfDay: Int
}

final class MedicationIntakeInfoItem: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var reasonForTaking: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var numberOfTakingPerDay: Int
    @Persisted var intervalOfTaking: Int
    @Persisted var startTimeOfDay: Int
    
    convenience init(reasonForTaking: String, startDate: Date, endDate: Date, numberOfTaking: Int, intervalOfTaking: Int, startTimeOfDay: Int) {
        self.init()
        
        self.reasonForTaking = reasonForTaking
        self.startDate = startDate
        self.endDate = endDate
        self.numberOfTakingPerDay = numberOfTakingPerDay
        self.intervalOfTaking = intervalOfTaking
        self.startTimeOfDay = startTimeOfDay
    }
}
