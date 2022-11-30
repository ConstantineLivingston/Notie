//
//  ViewController.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 21.11.2022.
//

import UIKit
import CoreData
import LazyHelper

final class NoteListViewController: UITableViewController {
    
    private let notesCountLabel = UILabel()
    private let searchController = UISearchController()
    
    var dataSource: DataSource!
    let storageManager: CoreDataManager
    var fetchedResultsController: NSFetchedResultsController<Note>!
    
    init(storageManager: CoreDataManager, style: UITableView.Style) {
        self.storageManager = storageManager
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
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
    
    private func configureViews() {
        view.backgroundColor = .secondarySystemBackground
        configureTableView()
        configureNotesCountLabel()
        setupToolBarItems()
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

    func setupFetchedResultsController(filter: String? = nil) {
        fetchedResultsController = storageManager.createFetchedResultsController(filter: filter)
        fetchedResultsController.delegate = self
    
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func setupToolBarItems() {
        let flexibleSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        let notesCountItem = UIBarButtonItem(customView: notesCountLabel)
        let systemImage = UIImage(systemName: "square.and.pencil")
        let addNoteButton = UIBarButtonItem(image: systemImage,
                                            style: .plain,
                                            target: self,
                                            action: #selector(didTapAddNoteButton(_:)))
        addNoteButton.tintColor = .systemOrange
        toolbarItems = [flexibleSpace, notesCountItem, flexibleSpace ,addNoteButton]
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
