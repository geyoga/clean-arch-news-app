//
//  NewsListRepository.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

protocol NewsListRepository {
    func fetchNewsList() async throws -> NewsPage
}
