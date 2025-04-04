//
//  NewsDto.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct NewsDto: Decodable {
    let source: SourceDto
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

extension NewsDto {
    func toDomain() -> News {
        .init(
            id: UUID(),
            title: title,
            description: description,
            imageUrl: urlToImage,
            source: source.toDomain()
        )
    }
}
