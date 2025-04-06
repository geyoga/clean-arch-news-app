//
//  CoreDataNewsListStorage.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

final class CoreDataNewsListStorage: NewsListStorage {

    struct Config {
        let maxAliveTimeInSecond: TimeInterval
    }

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date
    private let config: Config

    init(
        coreDataStorage: CoreDataStorage = .shared,
        currentTime: @escaping () -> Date,
        config: Config
    ) {
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
        self.config = config
    }

    // MARK: - Private

    private func fetchNewsPageRequest() -> NSFetchRequest<NewsPageEntity> {
        let request: NSFetchRequest = NewsPageEntity.fetchRequest()

        return request
    }

    private func deleteNewsListPageDto(in context: NSManagedObjectContext) {
        let request = fetchNewsPageRequest()
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }

    func getNewsListPageDto() async throws -> NewsListStorageItem? {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest: NSFetchRequest = self.fetchNewsPageRequest()
                    let entity = try context.fetch(fetchRequest).first
                    let entityDto = try entity?.toDto()

                    if let savedAt = entity?.savedAt,
                       self.currentTime().timeIntervalSince(savedAt) > self.config.maxAliveTimeInSecond {
                        continuation.resume(returning: entityDto.map({ .outdated($0) }))
                    } else {
                        continuation.resume(returning: entityDto.map({ .upToDate($0) }))
                    }
                } catch {
                    continuation.resume(throwing: CoreDataStorageError.readError(error))
                }
            }
        }
    }
    
    func save(newsResponseDto: NewsResponseDto) async throws {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStorage.performBackgroundTask { context in
                do {
                    self.deleteNewsListPageDto(in: context)

                    let entity = newsResponseDto.toEntity(in: context)
                    entity.savedAt = self.currentTime()
                    
                    try context.save()
                    continuation.resume()
                } catch {
                    assertionFailure("CoreDataUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
                }
            }
        }
    }
    
}
