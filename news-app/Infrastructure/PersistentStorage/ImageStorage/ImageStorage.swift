//
//  ImageStorage.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation

protocol ImageStorage {
    func getImageData(for urlPath: String) async throws -> Data?
    func save(imageData: Data, for urlPath: String) async throws
}
