//
//  NewsListUseCase.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

protocol NewsListUseCase {
    func fetchNewsList(request: NewsListUseCaseRequestValue) async throws -> NewsPage
}

final class DefaultNewsListUseCase: NewsListUseCase {

    private let repository: NewsListRepository

    init(repository: NewsListRepository) {
        self.repository = repository
    }

    func fetchNewsList(request: NewsListUseCaseRequestValue) async throws -> NewsPage {
        return try await repository.fetchNewsList(query: request.query, page: request.page)
    }
}

struct NewsListUseCaseRequestValue {
    let query: String
    let page: Int
}
