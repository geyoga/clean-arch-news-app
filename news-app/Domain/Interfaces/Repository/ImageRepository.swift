//
//  ImageRepository.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation

protocol ImageRepository {
    func fetchImage(with imagePath: String) async throws -> Data
}
