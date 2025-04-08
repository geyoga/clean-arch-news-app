//
//  NewsListRepository.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

protocol NewsListRepository {
    func fetchNewsList(query: String, page: Int) async throws -> NewsPage
}
