//
//  NetworkError.swift
//  news-app
//
//  Created by Georgius Yoga on 3/4/25.
//
import Foundation

enum NetworkError: Error {
    case badURL
    case badHostname
    case failed
    case noResponse
    case noData
    case unableToDecode
    case notConnected
    case generic
    case genericWith(Error)
    var description: String {
        switch self {
        case .badURL: return "Bad URL"
        case .badHostname: return "A server with the specified hostname could not be found"
        case .failed: return "Network Request Failed"
        case .noResponse: return "No response"
        case .noData: return "No Data"
        case .unableToDecode: return "Response can't be decoded"
        case .notConnected: return "The internet connection appears to be offline"
        case .generic: return "Something went wrong"
        case .genericWith(let error): return "Something went wrong with \(error.localizedDescription)"
        }
    }

    static func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cannotFindHost: return .badHostname
        default: return .genericWith(error)
        }
    }
}
