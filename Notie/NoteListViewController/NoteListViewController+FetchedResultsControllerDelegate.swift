//
//  NoteListViewController+FetchedResultsControllerDelegate.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 22.11.2022.
//

import UIKit
import CoreData

extension NoteListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        let shouldAnimate = tableView.numberOfSections != 0
        dataSource.apply(snapshot, animatingDifferences: shouldAnimate)
        refreshNotesCountLabel()
    }
}
