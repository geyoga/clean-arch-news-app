//
//  DefaultNewsListReposity.swift
//  news-app
//
//  Created by Georgius Yoga on 3/4/25.
//

import Foundation

final class DefaultNewsListReposity: NewsListRepository {

    private let dataTransferService: DataTransferService
    private let cache: NewsListStorage
    
    init(dataTransferService: DataTransferService, cache: NewsListStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }

//    func fetchNewsList() async throws -> NewsPage {
//        let request = NewsRequestQuery(query: "ios")
//        let endpoint = APIEndpoints.News.getAll(requestQuery: request)
//        return try await dataTransferService.request(with: endpoint).toDomain()
//    }

    func fetchNewsList(cached: (NewsPage) -> Void) async throws -> NewsPage {

        let cacheResult = await cache.getNewsListPageDto()

        var shouldFetchData: Bool
    }

}
