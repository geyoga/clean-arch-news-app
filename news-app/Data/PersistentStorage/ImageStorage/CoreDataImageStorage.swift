//
//  CoreDataImageStorage.swift
//  news-app
//
//  Created by Georgius Yoga on 5/4/25.
//

import Foundation
import CoreData

final class CoreDataImageStorage: ImageStorage {

    static let maxSizeInBytes = 200 * 1_000_000 // 200 MB

    private let coreDataStorage: CoreDataStorage
    private let currentTime: () -> Date

    init(
        coreDataStorage: CoreDataStorage = .shared,
        currentTime: @escaping () -> Date
    ) {
        self.coreDataStorage = coreDataStorage
        self.currentTime = currentTime
    }

    // MARK: - Private

    private func fetchRequest(
        for pathUrl: String
    ) -> NSFetchRequest<ImageEntity> {

        let request: NSFetchRequest = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(ImageEntity.pathUrl), pathUrl
        )
        return request
    }

    private func deleteImage(
        for urlPath: String,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: urlPath)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }

    static func removeLeastRecentlyUsedImages() {
        CoreDataStorage.shared.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest = ImageEntity.fetchRequest()
                
                let sort = NSSortDescriptor(
                    key: #keyPath(ImageEntity.lastUsedAt),
                    ascending: false
                )
                fetchRequest.sortDescriptors = [sort]
                
                let entities = try context.fetch(fetchRequest)
                
                var totalSizeUsed = 0
                entities.forEach { entity in
                    totalSizeUsed += (entity.data as? NSData)?.length ?? 0
                    if totalSizeUsed > self.maxSizeInBytes {
                        context.delete(entity)
                    }
                }

                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    // MARK: - Image Storage

    func getImageData(for urlPath: String) async throws -> Data? {
        try await withCheckedThrowingContinuation { continuation in
            coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest(for: urlPath)
                    let entity = try context.fetch(fetchRequest).first

                    entity?.lastUsedAt = self.currentTime()

                    try context.save()

                    continuation.resume(returning: entity?.data)
                } catch {
                    continuation.resume(throwing: CoreDataStorageError.readError(error))
                }
            }
        }
    }

    func save(imageData: Data, for urlPath: String) async {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteImage(for: urlPath, in: context)

                let entity: ImageEntity = .init(context: context)
                entity.data = imageData
                entity.pathUrl = urlPath
                entity.lastUsedAt = self.currentTime()

                try context.save()
            } catch {
                assertionFailure("CoreDataUsersStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

}
