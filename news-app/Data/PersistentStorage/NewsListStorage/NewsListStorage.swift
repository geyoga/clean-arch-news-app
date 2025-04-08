//
//  NewsListStorage.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation

enum NewsListStorageItem {
    case upToDate(NewsResponseDto)
    case outdated(NewsResponseDto)
}

protocol NewsListStorage {
    func getNewsListPageDto(for request: NewsRequestQueryDto) async throws -> NewsListStorageItem?
    func save(for request: NewsRequestQueryDto, newsResponseDto: NewsResponseDto) async throws
}
