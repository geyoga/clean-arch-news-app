//
//  SourceDto.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

struct SourceDto: Decodable {
    let id: String?
    let name: String
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}

extension SourceDto {
    func toDomain() -> Source {
        .init(id: id, name: name)
    }
}
