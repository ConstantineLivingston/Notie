//
//  NoteListViewController+TableViewDelegate.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 22.11.2022.
//

import UIKit

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTitle = NSLocalizedString("Delete", comment: "Delete trailing action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteTitle) { _, _, completion in
            let note = self.fetchedResultsController.object(at: indexPath)
            self.storageManager.deleteNote(note)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = note(for: indexPath)
        goToEditNote(with: note)
    }
}
