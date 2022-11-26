//
//  NoteViewController.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 23.11.2022.
//

import UIKit
import LazyHelper

final class NoteViewController: UIViewController {
    
    private let textView = UITextView()
    let storageManager: CoreDataManager
    var note: Note
    
    init(note: Note, storageManager: CoreDataManager) {
        self.note = note
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
        constrainViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        if note.text?.isEmpty ?? true {
            textView.becomeFirstResponder()
        }
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        textView.text = note.text
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.delegate = self
        textView.contentInset = UIEdgeInsets(top: 10,
                                             left: 16,
                                             bottom: 10,
                                             right: 16)
    }
    
    private func constrainViews() {
        view.addConstrainedSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    func deleteNote() {
        storageManager.deleteNote(note)
    }
    
    func updateNote() {
        note.lastUpdated = Date()
        storageManager.saveContext()
    }
}
