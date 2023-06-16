//
//  DateExtensions.swift
//  photosApp
//
//  Created by Tiara H on 16/06/23.
//

import Foundation

extension Date {
    func createDateForHeader() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
