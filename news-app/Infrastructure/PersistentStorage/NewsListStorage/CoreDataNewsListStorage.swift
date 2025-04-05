//
//  CoreDataNewsListStorage.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

final class CoreDataNewsListStorage: NewsListStorage {

    struct Config {
        let maxAliveTimeInSecond: TimeInterval
    }

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date
    private let config: Config

    init(
        coreDataStorage: CoreDataStorage = .shared,
        currentTime: @escaping () -> Date,
        config: Config
    ) {
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
        self.config = config
    }

    // MARK: - Private

    private func fetchNewsListPageRequest() -> {
        NSFetchRequest<NewsListRepositoriesPageEntity>
    }
}
