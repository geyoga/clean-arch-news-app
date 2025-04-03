//
//  DefaultNewsListReposity.swift
//  news-app
//
//  Created by Georgius Yoga on 3/4/25.
//

import Foundation

final class DefaultNewsListReposity: NewsListRepository {

    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }

    func fetchNewsList() async throws -> NewsPage {
        let endpoint = 
        try await dataTransferService.request(with: <#T##ResponseRequestable#>)
    }
    
    
}
