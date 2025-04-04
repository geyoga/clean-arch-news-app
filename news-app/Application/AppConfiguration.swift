//
//  AppConfiguration.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//
import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: URL = URL(string: "https://newsapi.org")!
    let cacheMaxAliveTimeInSecond: TimeInterval = 60 * 60
    let shouldLogNetworkRequest: Bool = true
}
