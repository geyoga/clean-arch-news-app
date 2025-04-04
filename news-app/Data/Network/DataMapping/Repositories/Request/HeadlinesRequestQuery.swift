//
//  HeadlinesRequestQuery.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct HeadlinesRequestQuery: Encodable {

    var country: String = "us"
    var query: String
    var category: String
    var pageSize: Int = 20
    var page: Int = 1

    private enum CodingKeys:String, CodingKey {
        case country
        case query = "q"
        case category
        case pageSize
        case page
    }
}
