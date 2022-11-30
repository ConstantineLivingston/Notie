//
//  Note+CoreDataClass.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 22.11.2022.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    var title: String {
        let lines = text?.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        return lines?.first ?? "Text Title"
    }
    
    var desc: String {
        var text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
        text?.removeFirst()
        return "\(lastUpdated?.creationDate() ?? "") \(text?.first ?? "No additional text")"
    }
}
