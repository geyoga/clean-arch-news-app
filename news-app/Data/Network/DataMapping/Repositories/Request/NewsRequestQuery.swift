//
//  NewsRequestQuery.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct NewsRequestQuery: Encodable {

    let query: String

    private enum CodingKeys: String, CodingKey {
        case query = "q"
    }
}
