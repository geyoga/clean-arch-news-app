//
//  AppFlowCoordinator.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let newsListFeatureDIContainer = appDIContainer.makeNewsListFeatureDIContainer()
        let flow = newsListFeatureDIContainer.makeNewsListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
