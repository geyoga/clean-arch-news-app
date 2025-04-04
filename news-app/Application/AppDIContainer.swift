//
//  AppDIContainer.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

final class AppDIContainer {

    // MARK: - App Config

    lazy var appConfiguration = AppConfiguration()

    // MARK: - App Network

    lazy var apiDataTransferService: DataTransferService = {
        
        let secretKey = SecretsManager()
        let headers = [HTTP.authorization: secretKey.getKeyandSaveToKeychain(key: .news)]

        let config = ApiDataNetworkConfig(
            baseURL: appConfiguration.apiBaseURL,
            headers: headers
        )

        let apiDataNetwork = DefaultNetworkService(
            config: config,
            logger: DefaultNetworkLogger(
                shouldLogRequests: appConfiguration.shouldLogNetworkRequest
            )
        )

        return DefaultDataTransferService(with: apiDataNetwork)
    }()

    // MARK: - DIContainers of feature

    func makeNewsListFeatureDIContainer() -> NewsListFeatureDIContainer {
        let dependencies = NewsListFeatureDIContainer.Dependencies(
            apiDataTransferService: apiDataTransferService,
            appConfiguration: appConfiguration
        )

        return NewsListFeatureDIContainer(dependencies: dependencies)
    }
}
