//
//  NetworkService.swift
//  news-app
//
//  Created by Georgius Yoga on 3/4/25.
//

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable) async throws -> Data?
    func url(for endpoint: Requestable) throws -> URL
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (data: Data, response: URLResponse)
}

protocol NetworkLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Default Network Service

final class DefaultNetworkService: NetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkLogger

    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkLogger
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }

    func request(endpoint: any Requestable) async throws -> Data? {
        let urlRequest = try endpoint.urlRequest(with: config)
        logger.log(request: urlRequest)
        do {
            let (data, response) = try await sessionManager.request(urlRequest)
            logger.log(responseData: data, response: response)
            return data
        } catch {
            logger.log(error: error)
            throw NetworkError.resolve(error: error)
        }
    }

    func url(for endpoint: any Requestable) throws -> URL {
        try endpoint.url(with: config)
    }
}

// MARK: - Default Network Session Manager

final class DefaultNetworkSessionManager: NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (data: Data, response: URLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpRensponse = response as? HTTPURLResponse else {
            throw NetworkError.genericWith(NSError(domain: "Network", code: -1))
        }
        return (data, httpRensponse)
    }
}

// MARK: - Default Network Logger

final class DefaultNetworkLogger: NetworkLogger {

    private let shouldLogRequests: Bool

    init(shouldLogRequests: Bool) {
        self.shouldLogRequests = shouldLogRequests
    }

    func log(request: URLRequest) {
        guard shouldLogRequests else { return }
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody,
           let result = ((try? JSONSerialization.jsonObject(
            with: httpBody,
            options: []) as? [String: AnyObject]) as [String: AnyObject]??
           ) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    func log(responseData data: Data?, response: URLResponse?) {
        guard shouldLogRequests else { return }
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(dataDict.prettyPrint())")
        }
    }

    func log(error: any Error) {
        printIfDebug("🔴 \(error)")
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let nstr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                string = nstr as String
            }
        }
        return string
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
