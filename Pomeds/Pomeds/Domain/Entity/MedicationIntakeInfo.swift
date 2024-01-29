//
//  MedicationIntakeInfo.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation
import SwiftData

struct MedicationIntakeInfo {
    var reasonForTaking: String
    var startDate: Date
    var endDate: Date
    var intervalOfTaking: Int
    var startTimeOfDay: Int
    var isTakingMorningMedication: Bool
}

@Model
final class MedicationIntakeInfoItem {
    var reasonForTaking: String
    var startDate: Date
    var endDate: Date
    var intervalOfTaking: Int
    var startTimeOfDay: Int
    var isTakingMorningMedication: Bool
    
    init(reasonForTaking: String, startDate: Date, endDate: Date, intervalOfTaking: Int, startTimeOfDay: Int, isTakingMorningMedication: Bool) {
        self.reasonForTaking = reasonForTaking
        self.startDate = startDate
        self.endDate = endDate
        self.intervalOfTaking = intervalOfTaking
        self.startTimeOfDay = startTimeOfDay
        self.isTakingMorningMedication = isTakingMorningMedication
    }
}
