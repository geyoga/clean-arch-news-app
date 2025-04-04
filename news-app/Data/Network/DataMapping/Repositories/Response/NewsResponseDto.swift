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
    let articles: [NewsDto]
}

extension NewsResponseDto {
    func toDomain() -> NewsPage {
        .init(items: articles.map({ $0.toDomain() }))
    }
}
