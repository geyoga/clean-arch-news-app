//
//  APIEndpoints.swift
//  news-app
//
//  Created by Georgius Yoga on 4/4/25.
//

import Foundation

struct APIEndpoints {

    enum News {

        static func getTopHeadlines(requestQuery: HeadlinesRequestQuery) -> Endpoint<NewsResponseDto> {

            return Endpoint(
                path: "v2/top-headlines",
                method: .get,
                queryParametersEncodable: requestQuery
            )
        }
        static func getAll(requestQuery: NewsRequestQuery) -> Endpoint<NewsResponseDto> {

            return Endpoint(
                path: "v2/everything",
                method: .get,
                queryParametersEncodable: requestQuery
            )
        }
        static func getSources(requestQuery: SourcesRequestQuery) -> Endpoint<SourceResponseDto> {

            return Endpoint(
                path: "v2/top-headlines/sources",
                method: .get,
                queryParametersEncodable: requestQuery
            )
        }

        static func getImage(path: String) -> Endpoint<Data> {

            return Endpoint(
                path: path,
                method: .get,
                responseDecoder: RawDataResponseDecoder()
            )
        }
    }

}
