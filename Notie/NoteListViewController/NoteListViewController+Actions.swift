//
//  NoteListViewController+Actions.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 23.11.2022.
//

import UIKit

extension NoteListViewController {
    @objc func didTapAddNoteButton(_ sender: UIBarButtonItem) {
        let note = storageManager.createNote()
        goToEditNote(with: note)
    }
}
