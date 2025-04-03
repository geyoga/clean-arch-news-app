//
//  NewsListViewController.swift
//  news-app
//
//  Created by Georgius Yoga on 2/4/25.
//

import UIKit
import Combine

final class NewsListViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: NewsListViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    private lazy var tableController: NewsListTableViewController = {
        let controller = NewsListTableViewController(viewModel: viewModel)

        return controller
    }()
    
    // MARK: - Life Cycles

    init(viewModel: NewsListViewModel) {
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
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupViewLayout() {
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
                    "Ok",
                    comment: ""
                ),
                style: UIAlertAction.Style.default,
                handler: nil
            )
        )
        present(alert, animated: true)
    }
}
