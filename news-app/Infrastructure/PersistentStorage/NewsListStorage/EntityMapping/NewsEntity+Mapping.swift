//
//  NewsEntity+Mapping.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

enum MappingNewsEntityError: Error {
    case missingSourceData
    case missingData
}

// MARK: - Mapping to Dto

extension NewsEntity {
    func toDto() throws -> NewsDto {
        let sourceDto = try source?.toDto()
        guard let title = title else {
            throw MappingNewsEntityError.missingData
        }
        return .init(
            source: sourceDto,
            author: author,
            title: title,
            description: descriptionText,
            url: url,
            urlToImage: imageUrl,
            publishedAt: publishedAt,
            content: content
        )
    }
}

// MARK: - Mapping to CoreData Entity

extension NewsDto {
    
    func toEntity(in context: NSManagedObjectContext) -> NewsEntity {

        let entity: NewsEntity = .init(context: context)
        entity.title = title
        entity.author = author
        entity.content = content
        entity.descriptionText = description
        entity.imageUrl = urlToImage
        entity.publishedAt = publishedAt

        return entity
    }
    
}
