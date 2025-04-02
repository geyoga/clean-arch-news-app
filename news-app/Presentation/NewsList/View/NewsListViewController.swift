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
            .sink { data in
                print(data)
            }.store(in: &cancellables)
    }

    private func setupLocalizations() {
        title = "News App"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupViewLayout() {
        view.backgroundColor = .white
    }
}
