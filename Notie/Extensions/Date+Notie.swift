//
//  Date+Notie.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 23.11.2022.
//

import Foundation

extension Date {
    func creationDate() -> String {
        let formatter = DateFormatter()
        if Locale.current.calendar.isDateInToday(self) {
            formatter.dateFormat = "h:mm a"
        } else {
            formatter.dateFormat = "dd.MM.yyyy"
        }
        return formatter.string(from: self)
    }
}
