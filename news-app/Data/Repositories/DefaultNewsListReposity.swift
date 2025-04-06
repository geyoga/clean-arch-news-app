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

    init(
        dataTransferService: DataTransferService,
        cache: NewsListStorage
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }

    func fetchNewsList() async throws -> NewsPage {

        var cacheResult: NewsListStorageItem?

        do {
            cacheResult = try await cache.getNewsListPageDto()
        } catch {
            print("⚠️ Cache fetch failed: \(error.localizedDescription)")
        }

        switch cacheResult {
        case .upToDate(let newsResponseDto):
            return newsResponseDto.toDomain()
        case .outdated(_):
            break
        case nil:
            break
        }

        try Task.checkCancellation()

        let request = NewsRequestQuery(query: "iOS")
        let endpoint = APIEndpoints.News.getAll(requestQuery: request)

        let resultData = try await dataTransferService.request(with: endpoint)
        try await cache.save(newsResponseDto: resultData)

        return resultData.toDomain()
    }

}
