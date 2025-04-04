//
//  News.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

struct News: Equatable {
    let id: UUID
    let title: String
    let description: String
    let imageUrl: String
    let source: Source
}
