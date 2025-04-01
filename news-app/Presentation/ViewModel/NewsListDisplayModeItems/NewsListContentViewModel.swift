//
//  NewsListContentViewModel.swift
//  news-app
//
//  Created by Georgius Yoga on 1/4/25.
//

enum NewsListContentViewModel: Hashable {
    case items([NewsListItemViewModel])
    case emptyData
    case loading
}
