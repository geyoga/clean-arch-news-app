//
//  Category.swift
//  news-app
//
//  Created by Georgius Yoga on 8/4/25.
//

import Foundation

enum CategoryType: String {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

struct Category: Equatable {
    let type: CategoryType
}
