//
//  SourcesRequestQuery.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct SourcesRequestQuery: Encodable {

    let category: String
    let language: String
    let country: String

    private enum CodingKeys: CodingKey {
        case category
        case language
        case country
    }
}
