//
// Copyright © 2020 Stormwright. All rights reserved.
//

import CoreData

public final class CoreDataRatesFeedStore {
    private static let modelName = "RatesFeedStore"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataRatesFeedStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext

    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }

    public init(storeURL: URL) throws {
        guard let model = CoreDataRatesFeedStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataRatesFeedStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }

    func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
    private func cleanUpReferencesToPersistentStores() {
        context.performAndWait {
            let coordinator = self.container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
    
    deinit {
        cleanUpReferencesToPersistentStores()
    }
}
