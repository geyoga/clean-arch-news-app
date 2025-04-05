//
//  SourceEntity+Mapping.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

enum MappingSourceEntityError: Error {
    case missingData
}

extension SourceEntity {
    func toDto() throws -> SourceDto {
        guard let id = id, let name = name else {
            throw MappingSourceEntityError.missingData
        }
        return .init(
            id: id,
            name: name,
            description: nil,
            url: nil,
            category: nil,
            language: nil,
            country: nil
        )
    }
}

extension SourceDto {
    func toEntity(in context: NSManagedObjectContext) -> SourceEntity {
        let entity: SourceEntity = .init(context: context)
        entity.id = id
        entity.name = name

        return entity
    }
}
