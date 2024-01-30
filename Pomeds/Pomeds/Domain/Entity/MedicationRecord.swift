//
//  MedicationRecord.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/29/24.
//

import Foundation

import RealmSwift

/**
 약물의 기록을 나타내는 엔티티입니다.
 - parameter efficacy: - 효능
 - parameter manufacturer: - (Optional) 제조 회사
 */
struct MedicationRecord {
    var isTakingNow: Bool
    var reasonForMedication: String
    var startDate: Date
    var endDate: Date
    var pillName: String
    var manufacturer: String?
    var efficacy: String
    var sideEffects: [String]
    var medicationType: String
}

/**
 MedicationRecord 의 SwiftData 포맷입니다.
 */
final class MedicationRecordItem: Object {
    @Persisted var _id: ObjectId
    @Persisted var isTakingNow: Bool
    @Persisted var reasonForMedication: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var pillName: String
    @Persisted var manufacturer: String?
    @Persisted var efficacy: String
    @Persisted var sideEffects: List<String>
    /// 약과 영양제 타입 총 2가지로 나뉩니다.
    /// enum MedicationType:
    /// - medication
    /// - supplements
    @Persisted var medicationType: String
    
    convenience init(isTakingNow: Bool, reasonForMedication: String, startDate: Date, endDate: Date, pillName: String, manufacturer: String? = nil, efficacy: String, sideEffects: List<String>, medicationType: String) {
        self.init()
        
        self.isTakingNow = isTakingNow
        self.reasonForMedication = reasonForMedication
        self.startDate = startDate
        self.endDate = endDate
        self.pillName = pillName
        self.manufacturer = manufacturer
        self.efficacy = efficacy
        self.sideEffects = sideEffects
        self.medicationType = medicationType
    }
}

enum MedicationType {
    case medication
    case supplements
    
    var stringRequest: String {
        switch self {
        case .medication:
            return "med"
        case .supplements:
            return "supl"
        }
    }
}
