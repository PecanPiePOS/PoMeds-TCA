//
//  MedicationRecord.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation
import SwiftData

/**
 약물의 기록을 나타내는 엔티티입니다.
 - parameter efficacy: - 효능
 - parameter manufacturer: - (Optional) 제조 회사
 */
struct MedicationRecord {
    var reasonForMedication: String
    var startDate: Date
    var endDate: Date
    var pillName: String
    var manufacturer: String?
    var efficacy: String
    var sideEffects: [String]
}

/**
 MedicationRecord 의 SwiftData 포맷입니다.
 */
@Model
final class MedicationRecordItem {
    var reasonForMedication: String
    var startDate: Date
    var endDate: Date
    var pillName: String
    var manufacturer: String?
    var efficacy: String
    var sideEffects: [String]
    
    init(reasonForMedication: String, startDate: Date, endDate: Date, pillName: String, manufacturer: String? = nil, efficacy: String, sideEffects: [String]) {
        self.reasonForMedication = reasonForMedication
        self.startDate = startDate
        self.endDate = endDate
        self.pillName = pillName
        self.manufacturer = manufacturer
        self.efficacy = efficacy
        self.sideEffects = sideEffects
    }
}
