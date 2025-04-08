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

    func fetchNewsList(query: String, page: Int) async throws -> NewsPage {

        var cacheResult: NewsListStorageItem?
        let request = NewsRequestQueryDto(query: query, page: page)

        do {
            cacheResult = try await cache.getNewsListPageDto(for: request)
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

        let endpoint = APIEndpoints.News.getAll(requestQuery: request)

        let resultData = try await dataTransferService.request(with: endpoint)

        if let _ = resultData.message {
            if case let .outdated(dto) = cacheResult {
                return dto.toDomain()
            } else {
                throw NetworkError.failed
            }
        } else {
            try await cache.save(for: request, newsResponseDto: resultData)

            return resultData.toDomain()
        }
    }

}
