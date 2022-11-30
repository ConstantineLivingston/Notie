//
//  ViewController.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 21.11.2022.
//

import UIKit
import CoreData
import LazyHelper

final class NoteListViewController: UIViewController {
    
    let tableView: UITableView
    private let addNoteButton = UIButton()
    private let notesCountLabel = UILabel()
    private let bottomView = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    private let searchController = UISearchController()
    
    var dataSource: DataSource!
    let storageManager: CoreDataManager
    var fetchedResultsController: NSFetchedResultsController<Note>!
    
    init(storageManager: CoreDataManager, style: UITableView.Style) {
        self.storageManager = storageManager
        tableView = UITableView(frame: .zero, style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        constrainViews()
        setupSearchController()
        setupNavigationItem()
        setupDataSource()
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
        
    func refreshNotesCountLabel() {
        let count = fetchedResultsController.fetchedObjects?.count
        notesCountLabel.text = "\(count ?? 0) Notes"
    }
    
    func goToEditNote(with note: Note) {
        let viewController = NoteViewController(note: note,
                                                storageManager: storageManager)
        show(viewController, sender: self)
    }
    
    private func setupToolBarItems() {
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        
        let systemImage = UIImage(systemName: "square.and.pencil")
        let addNoteButton = UIBarButtonItem(image: systemImage,
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapAddNoteButton(_:)))
        addNoteButton.tintColor = .systemOrange
        
        toolbarItems = [flexibleSpace, addNoteButton]
    }

    func setupFetchedResultsController(filter: String? = nil) {
        fetchedResultsController = storageManager.createFetchedResultsController(filter: filter)
        fetchedResultsController.delegate = self
    
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupNavigationItem() {
        let title = NSLocalizedString("My Notes",
                                      comment: "Notes List view controller title")
        navigationItem.title = title
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func configureNotesCountLabel() {
        notesCountLabel.font = UIFont.systemFont(ofSize: 14)
        notesCountLabel.textColor = .darkGray
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        configureTableView()
        configureNotesCountLabel()
        setupToolBarItems()
    }

    private func constrainViews() {
        view.addConstrainedSubviews(tableView)
//                                    blurView,
//                                    bottomView)
//        bottomView.addConstrainedSubviews(notesCountLabel,
//                                          addNoteButton)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            notesCountLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
//            notesCountLabel.heightAnchor.constraint(equalToConstant: 20),
//            notesCountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10),
//            notesCountLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10),
//
//            addNoteButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
//            addNoteButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20),
//
//            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//
//            blurView.topAnchor.constraint(equalTo: bottomView.topAnchor),
//            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension NoteListViewController {
    func searchNote(text: String) {
        if text.isEmpty {
            setupFetchedResultsController()
        } else {
            setupFetchedResultsController(filter: text)
        }
    }
}
