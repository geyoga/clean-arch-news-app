//
//  NewsListContentViewModel.swift
//  news-app
//
//  Created by Georgius Yoga on 1/4/25.
//

import Foundation

enum NewsListContentViewModel: Hashable {
    case items([NewsListItemViewModel])
    case emptyData
    case loadingShimmer
    case loadingSpinner
}
