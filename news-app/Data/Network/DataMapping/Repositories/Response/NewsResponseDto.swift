//
//  ResponseDto.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct NewsResponseDto: Decodable {
    let status: String
    let totalResults: Int?
    let code: String?
    let message: String?
    let articles: [NewsDto]?
    let page: Int?
    let query: String?
}

extension NewsResponseDto {
    func toDomain() -> NewsPage {
        if let articles = articles {
            return .init(items: articles.map({ $0.toDomain() }))
        } else {
            return NewsPage(items: [])
        }
    }
}
