//
//  NewsListFlowCoordinator.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import UIKit

protocol NewsListFlowCoordinatorDependencies {
    func makeNewsListViewController() -> NewsListViewController
}

final class NewsListFlowCoordinator {

    private weak var navigationController: UINavigationController?
    private let dependencies: NewsListFlowCoordinatorDependencies

    init(navigationController: UINavigationController, dependencies: NewsListFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let viewController = dependencies.makeNewsListViewController()
        navigationController?.pushViewController(viewController, animated: false)
    }
}
