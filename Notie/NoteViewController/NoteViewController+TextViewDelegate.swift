//
//  NoteViewController+TextViewDelegate.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 23.11.2022.
//

import UIKit

extension NoteViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        note.text = textView.text
        if note.text?.isEmpty ?? true {
            deleteNote()
        } else {
            updateNote()
        }
    }
}
