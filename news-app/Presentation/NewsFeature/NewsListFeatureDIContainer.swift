//
//  NewsListFeatureDIContainer.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import UIKit

final class NewsListFeatureDIContainer: NewsListFlowCoordinatorDependencies {

    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
        let appConfiguration: AppConfiguration
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage

    lazy var newsListStorage: NewsListStorage = CoreDataNewsListStorage(
        currentTime: { Date() },
        config: .init(
            maxAliveTimeInSecond: dependencies
                .appConfiguration
                .cacheMaxAliveTimeInSecond
        )
    )
    lazy var imageCache: ImageStorage = CoreDataImageStorage(currentTime: { Date() })

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - View Controller
    func makeNewsListViewController() -> NewsListViewController {
        NewsListViewController(
            viewModel: makeNewsListViewModel(),
            imageRepository: makeImageRepository()
        )
    }

    // MARK: - View Model
    private func makeNewsListViewModel() -> NewsListViewModel {
        DefaultNewsListViewModel(newsListUsesCase: makeNewsListUseCase())
    }
    private func makeImageRepository() -> ImageRepository {
        DefaultImageRepository(
            dataTransferService: dependencies.imageDataTransferService,
            imageCache: imageCache
        )
    }

    // MARK: - Use Cases
    private func makeNewsListUseCase() -> NewsListUseCase {
        DefaultNewsListUseCase(repository: makeNewsListRepository())
    }

    // MARK: - Repository
    private func makeNewsListRepository() -> NewsListRepository {
        DefaultNewsListReposity(
            dataTransferService: dependencies.apiDataTransferService,
            cache: newsListStorage
        )
    }
    
    // MARK: - Flow Coordinator

    func makeNewsListFlowCoordinator(navigationController: UINavigationController) -> NewsListFlowCoordinator {
        NewsListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
}
