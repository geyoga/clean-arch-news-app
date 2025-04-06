//
//  DefaultImageRepository.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation

enum ImageRepositoryError: Error {
    case invalidPathUrl
}

final class DefaultImageRepository: ImageRepository {

    private let dataTransferService: DataTransferService
    private let imageCache: ImageStorage

    init(
        dataTransferService: DataTransferService,
        imageCache: ImageStorage
    ) {
        self.dataTransferService = dataTransferService
        self.imageCache = imageCache
    }

    func fetchImage(with imagePath: String) async throws -> Data {

        let endpoint = APIEndpoints.News.getImage(path: imagePath)
        guard let pathUrlWithPath = try? dataTransferService.url(for: endpoint).absoluteString else {
            throw ImageRepositoryError.invalidPathUrl
        }
        if let cachedImage = try await imageCache.getImageData(for: pathUrlWithPath) {
            return cachedImage
        }
        let imageData = try await dataTransferService.request(with: endpoint)
        try await imageCache.save(imageData: imageData, for: pathUrlWithPath)

        return imageData
    }
}
