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
        try await repository.fetchNewsList()
    }
}

final class MockNewsListUseCase: NewsListUseCase {
    var response: NewsPage = .init(items: [
        News(id: 0, title: "Hello World 1", description: "Ini Test kebutuhan testing", imageUrl: "", source: .init(id: "AAA", name: "AAA Studio")),
        News(id: 1, title: "Hello World 2", description: "Ini Test kebutuhan testing", imageUrl: "", source: .init(id: "AAA", name: "AAA Studio")),
        News(id: 2, title: "Hello World 3", description: "Ini Test kebutuhan testing", imageUrl: "", source: .init(id: "AAA", name: "AAA Studio")),
        News(id: 3, title: "Hello World 4", description: "Ini Test kebutuhan testing", imageUrl: "", source: .init(id: "AAA", name: "AAA Studio"))
    ])
    var error: Error?
    func fetchNewsList() async throws -> NewsPage {
        if let error {
            throw error
        }
        return response
    }

}
