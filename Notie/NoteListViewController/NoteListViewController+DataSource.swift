//
//  NoteListViewController+DataSource.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 22.11.2022.
//

import UIKit
import LazyHelper
import CoreData

extension NoteListViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, NSManagedObjectID>
    
    func setupDataSource() {
        dataSource = DataSource(tableView: tableView,
                                cellProvider: cellProviderHandler)
    }
    
    private func cellProviderHandler(tableView: UITableView,
                             indexPath: IndexPath,
                                     id: NSManagedObjectID) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier,
                                                 for: indexPath)
        cell.contentConfiguration = cellConfiguration(for: cell,
                                                      with: id)
        return cell
    }
    
    private func cellConfiguration(for cell: UITableViewCell,
                                   with ObjectID: NSManagedObjectID) -> UIContentConfiguration {
        guard
            let managedObject = try? fetchedResultsController.managedObjectContext.existingObject(with: ObjectID)
        else { fatalError("Managed object should be available") }
        
        guard
            let note = managedObject as? Note
        else { fatalError("Typecast to Note has failed") }
        
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = note.title
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
        contentConfiguration.textProperties.numberOfLines = 1
        contentConfiguration.secondaryText = note.desc
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        contentConfiguration.secondaryTextProperties.numberOfLines = 1
        contentConfiguration.secondaryTextProperties.color = .gray
        return contentConfiguration
    }
    
    func note(for indexPath: IndexPath) -> Note {
        let note = fetchedResultsController.object(at: indexPath)
        return note
    }
}
