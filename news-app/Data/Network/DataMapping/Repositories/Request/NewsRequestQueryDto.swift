//
//  NewsRequestQuery.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct NewsRequestQueryDto: Encodable {

    enum SortBy: String, Encodable {
        case relevancy
        case popularity
        case publishedAt
    }

    let query: String
    let pageSize: Int = 10
    let page: Int
    let sortBy: SortBy = .relevancy

    private enum CodingKeys: String, CodingKey {
        case query = "q"
        case page
        case pageSize
        case sortBy
    }
}
