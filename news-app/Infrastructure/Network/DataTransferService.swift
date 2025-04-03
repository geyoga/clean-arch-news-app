//
//  DataTransferService.swift
//  news-app
//
//  Created by Georgius Yoga on 3/4/25.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T
    func request<E: ResponseRequestable>(with endpoint: E) async throws where E.Response == Void
    func url<E: ResponseRequestable>(for endpoint: E) throws -> URL
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

final class DefaultDataTransferService: DataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger

    init(
        networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }

    func request<T, E>(with endpoint: E) async throws -> T where T : Decodable, T == E.Response, E : ResponseRequestable {
        do {
            let data = try await networkService.request(endpoint: endpoint)
            guard let data = data else { throw DataTransferError.noResponse }
            return try endpoint.responseDecoder.decode(data)
        } catch let error as NetworkError {
            let resolvedError = errorResolver.resolve(error: error)
            errorLogger.log(error: error)
            throw resolvedError is NetworkError ? DataTransferError.networkFailure(error) : DataTransferError.resolvedNetworkFailure(resolvedError)
        } catch {
            errorLogger.log(error: error)
            throw DataTransferError.parsing(error)
        }
    }

    func request<E>(with endpoint: E) async throws where E : ResponseRequestable, E.Response == () {
        do {
            _ = try await networkService.request(endpoint: endpoint)
        } catch let error as NetworkError {
            let resolvedError = errorResolver.resolve(error: error)
            errorLogger.log(error: error)
            throw resolvedError is NetworkError
                ? DataTransferError.networkFailure(error)
                : DataTransferError.resolvedNetworkFailure(resolvedError)
        }
    }

    func url<E>(for endpoint: E) throws -> URL where E : ResponseRequestable {
        try networkService.url(for: endpoint)
    }

}

// MARK: - Logger

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    func log(error: Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - Response Decoders

class JSONResponseDecoder: ResponseDecoder {
    let jsonDecoder = JSONDecoder()
    func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.unableToDecode
        }
    }
}

class RawDataResponseDecoder: ResponseDecoder {
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
