//
//  NewsPageEntity+Mapping.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

enum MappingNewsPageEntityError: Error {
    case incorrectNewsEntity
}

// MARK: - Mapping to Dto

extension NewsPageEntity {

    func toDto() throws -> NewsResponseDto {
        return .init(
            status: "ok",
            totalResults: nil,
            code: nil,
            message: nil,
            articles: try articles?
                .map({
                    guard let entity = $0 as? NewsEntity else {
                        throw MappingNewsPageEntityError.incorrectNewsEntity
                    }
                    return try entity.toDto()
                }) ?? []
        )
    }
}

// MARK: - Mapping To CoreData Entity

extension NewsResponseDto {
    func toEntity(in context: NSManagedObjectContext) -> NewsPageEntity {
        let entity: NewsPageEntity = .init(context: context)

        if let articles = articles {
            entity.articles = NSSet(array: articles.map({$0.toEntity(in: context)}))
        } else {
            entity.articles = nil
        }
        return entity
    }
}
