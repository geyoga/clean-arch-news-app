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
    func getNewsListPageDto() async throws -> NewsListStorageItem?
    func save(newsResponseDto: NewsResponseDto) async throws
}
