//
//  NewsListItemViewModel.swift
//  news-app
//
//  Created by Georgius Yoga on 28/3/25.
//

import Foundation

struct NewsListItemViewModel: Hashable {
    struct NewsListSourceViewModel: Hashable {
        let name: String
    }
    struct NewsItemViewModel: Hashable {
        let id: UUID
        let title: String
        let source: NewsListSourceViewModel
        let description: String
    }
    let news: NewsItemViewModel
    var isExpanded: Bool = false
}

extension NewsListItemViewModel {
    init(news: News) {
        self.news = .init(
            id: news.id,
            title: news.title,
            source: .init(name: news.source.name),
            description: news.description
        )
    }
}
