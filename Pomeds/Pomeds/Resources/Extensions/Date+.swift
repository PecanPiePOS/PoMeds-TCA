//
//  Date+.swift
//  Pomeds
//
//  Created by KYUBO A. SHIM on 2/12/24.
//

import Foundation

extension Date {
    var shortened: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
