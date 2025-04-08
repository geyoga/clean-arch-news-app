//
//  NewsListViewController.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit
import Combine

private typealias `Self` = NewsListViewController

final class NewsListViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: NewsListViewModel
    private let imageRepository: ImageRepository
    private var cancellables: Set<AnyCancellable> = .init()
    private lazy var tableController: NewsListTableViewController = {
        let controller = NewsListTableViewController(viewModel: viewModel, imageRepository: imageRepository)

        return controller
    }()
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self

        return controller
    }()

    // MARK: - Life Cycles

    init(viewModel: NewsListViewModel, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLocalizations()
        setupViewLayout()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }

    // MARK: - Helpers

    private func bind(to viewModel: NewsListViewModel) {

        viewModel.content
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.updateItems()
            }.store(in: &cancellables)

        viewModel.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showError(error)
            }.store(in: &cancellables)
    }

    private func setupLocalizations() {
        title = "Daily News"
        searchController.searchBar.placeholder = "Search News"
    }

    private func setupViewLayout() {

        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true

        addChild(tableController)
        tableController.view.frame = view.bounds
        view.addSubview(tableController.view)
        tableController.didMove(toParent: self)
    }

    private func updateItems() {
        tableController.reload()
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        
        let alert = UIAlertController(
            title: NSLocalizedString(
                "Error",
                comment: ""
            ),
            message: error,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString(
                    "OK",
                    comment: ""
                ),
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        present(alert, animated: true)
    }
}

extension Self: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.lowercased() else { return }
        viewModel.didSearch(query: query)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
