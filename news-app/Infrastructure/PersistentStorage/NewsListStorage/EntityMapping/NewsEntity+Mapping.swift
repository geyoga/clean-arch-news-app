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

extension NewsEntity {
    func toDto() throws -> NewsDto {
        guard let sourceDto = try source?.toDto() else {
            throw MappingNewsEntityError.missingSourceData
        }
    }
}

extension NewsDto {
    
}
