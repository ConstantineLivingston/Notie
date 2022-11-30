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
    private var doneButton: UIBarButtonItem!
    private var shareButton: UIBarButtonItem!
    
    let storageManager: CoreDataManager
    var note: Note
    
    init(note: Note, storageManager: CoreDataManager) {
        self.note = note
        self.storageManager = storageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        constrainViews()
        configureNavigationItem()
        observeKeyboardNotification()
        
        if note.text?.isEmpty ?? true {
            textView.becomeFirstResponder()
        }
    }
    
    func observeKeyboardNotification() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(showDoneButton),
                         name: UIResponder.keyboardWillShowNotification,
                         object: nil)
        
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(hideDoneButton),
                         name: UIResponder.keyboardWillHideNotification,
                         object: nil)
    }
    
    @objc private func showDoneButton() {
        navigationItem.setRightBarButtonItems([doneButton, shareButton],
                                              animated: false)
    }
    
    @objc private func hideDoneButton() {
        navigationItem.setRightBarButtonItems([shareButton],
                                              animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
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
    
    private func configureNavigationItem() {
        shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                      target: self,
                                      action: #selector(shareNote))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(dismissKeyboard))
        navigationItem.rightBarButtonItems = [shareButton]
    }
    
    private func constrainViews() {
        view.addConstrainedSubviews(textView)
        
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

extension NoteViewController {
    @objc func shareNote() {
        guard let text = textView.text,
              !text.isEmpty
        else {
            showError(title: "Note is empty",
                      message: "You cannot share an empty note")
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [text],
                                                  applicationActivities: nil)
        activityVC.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(activityVC, animated: true)
    }
    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}
