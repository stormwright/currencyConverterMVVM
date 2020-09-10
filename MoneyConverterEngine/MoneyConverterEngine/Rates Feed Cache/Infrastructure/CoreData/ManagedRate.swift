//
// Copyright © 2020 Stormwright. All rights reserved.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedRate: NSManagedObject {
    @NSManaged var code: String
    @NSManaged var name: String
    @NSManaged var rate: Double
    @NSManaged var date: String
    @NSManaged var inverseRate: Double
    @NSManaged var cache: ManagedCache
}

extension ManagedRate {
    static func first(with code: String, in context: NSManagedObjectContext) throws -> ManagedRate? {
        let request = NSFetchRequest<ManagedRate>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedRate.code), code])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    static func rates(from localFeed: [LocalFeedRate], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedRate(context: context)
            managed.code = local.code
            managed.name = local.name
            managed.rate = local.rate
            managed.date = local.date
            managed.inverseRate = local.inverseRate
            return managed
        })
    }
    
    var local: LocalFeedRate {
        return LocalFeedRate(code: code, name: name, rate: rate, date: date, inverseRate: inverseRate)
    }
}

