//
//  SourceResponseDto.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct SourceResponseDto: Decodable {
    let status: String
    let code: String?
    let message: String?
    let sources: [SourceDto]
}

extension SourceResponseDto {
    func toDomain() -> [Source] {
        return sources.map({$0.toDomain()})
    }
}
