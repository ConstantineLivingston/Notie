//
//  Note+CoreDataProperties.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 22.11.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var lastUpdated: Date?
    @NSManaged public var text: String?

}

extension Note : Identifiable {

}
