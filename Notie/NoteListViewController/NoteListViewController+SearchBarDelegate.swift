//
//  NoteListViewController+SearchBarDelegate.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 29.11.2022.
//

import UIKit

extension NoteListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchNote(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchNote(text: "")
    }
}


