//
//  NewsListUseCase.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

protocol NewsListUseCase {
    func fetchNewsList() async throws -> NewsPage
}

final class DefaultNewsListUseCase: NewsListUseCase {

    private let repository: NewsListRepository

    init(repository: NewsListRepository) {
        self.repository = repository
    }

    func fetchNewsList() async throws -> NewsPage {
        return try await repository.fetchNewsList()
    }
}
