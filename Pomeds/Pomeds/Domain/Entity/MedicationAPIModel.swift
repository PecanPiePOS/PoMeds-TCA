//
//  MedicationResponse.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 1/31/24.
//

import Foundation

struct MedicationRequest: Encodable {
    let serviceKey: String
    let pageNo: Int
    let numOfRows: Int
    let itemName: String
    let type: String = "josn"
}

struct MedicationResponse: Decodable {
    let companyName: String
    let pillName: String
    let efficacy: String
    let howToUse: String
    let warning: String
    let sideEffect: String
    let pillImage: String?
    let itemSeq: String
    let atpnQesitm, intrcQesitm, depositMethodQesitm: String
    let openDe, updateDe: String
    let bizrno: String
    
    enum CodingKeys: String, CodingKey {
        case companyName = "entpName"
        case pillName = "itemName"
        case efficacy = "efcyQesitm"
        case howToUse = "useMethodQesitm"
        case warning = "atpnWarnQesitm"
        case sideEffect = "seQesitm"
        case pillImage = "itemImage"
        case itemSeq
        case atpnQesitm
        case intrcQesitm
        case depositMethodQesitm
        case openDe
        case updateDe
        case bizrno
    }
}
