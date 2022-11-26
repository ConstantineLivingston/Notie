//
//  CoreDataManager.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 21.11.2022.
//

import Foundation
import CoreData

protocol Storagable {
    
}

class CoreDataManager {
    static let shared = CoreDataManager(modelName: "Notie")
    
    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else { fatalError(error!.localizedDescription) }
            
            completion?()
        }
    }
    
    func fetchNotes(withCompletion completion: @escaping ([Note]) -> Void) {
        let fetchRequest = Note.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            completion(results)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createFetchedResultsController(filter: String? = nil) -> NSFetchedResultsController<Note> {
        let fetchRequest = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let filter = filter {
            let predicate = NSPredicate(format: "title contains[cd] %@", filter)
            fetchRequest.predicate = predicate
        }
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension CoreDataManager {
    func createNote() -> Note  {
        let note = Note(context: context)
        note.text = ""
        note.lastUpdated = Date()
        self.saveContext()
        return note
    }
    
    func deleteNote(_ note: Note) {
        context.delete(note)
        saveContext()
    }
}
