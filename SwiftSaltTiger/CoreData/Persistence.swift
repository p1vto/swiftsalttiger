//
//  Persistence.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 8/12/2021.
//

import Foundation
import CoreData

// MARK: Protocol Definition
protocol ManagedObjectProtocol {
    associatedtype Entity
    func toEntity() -> Entity
}

protocol ManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject, ManagedObjectProtocol

    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject
}


struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, err in
            if let err = err {
                print(err.localizedDescription)
            }
        }

        return container
    }()
    
    static func saveContext() {
        let context = shared.container.viewContext
        DispatchQueue.mainSync {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    fatalError("Error happens when saving context: \(error)")
                }
            }
        }
    }
    
}


extension PersistenceController {
    static func fetch<MO: NSManagedObject>(
        entityType: MO.Type,
        fetchLimit: Int = 0,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = true,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> [MO] {
        var results = [MO]()
        let context = shared.container.viewContext
        DispatchQueue.mainSync {
            let request = NSFetchRequest<MO>(
                entityName: String(describing: entityType)
            )
            request.predicate = predicate
            request.fetchLimit = fetchLimit
            request.sortDescriptors = sortDescriptors
            results = (try? context.fetch(request)) ?? []
        }
        return results
    }
    
    static func fetch<MO: NSManagedObject>(
        entityType: MO.Type,
        fetchLimit: Int = 0,
        predicate: NSPredicate? = nil,
        findBeforeFetch: Bool = true,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) -> MO? {
        var results = [MO]()
        let context = shared.container.viewContext
        DispatchQueue.mainSync {
            let request = NSFetchRequest<MO>(
                entityName: String(describing: entityType)
            )
            request.predicate = predicate
            request.fetchLimit = fetchLimit
            request.sortDescriptors = sortDescriptors
            results = (try? context.fetch(request)) ?? []
        }
        return results.first
    }
    
    static func createIfNotExist<MO: NSManagedObject>(
        entityType: MO.Type,
        commitChanges: ((MO?) -> Void)? = nil
    ) {
        if fetch(entityType: entityType).count > 0 {
            return
        } else {
            let newMO = MO(context: shared.container.viewContext)
            commitChanges?(newMO)
            saveContext()
        }
    }
    
    static func update<MO: NSManagedObject>(
        entityType: MO.Type,
        predicate: NSPredicate? = nil,
        createIfNil: Bool = false,
        commitChanges: ((MO) -> Void)
    ) {
        
        let storedMO: MO? = fetch(
            entityType: entityType,
            predicate: predicate
        )
        
        if let storedMO = storedMO {
            commitChanges(storedMO)
            saveContext()
        }
    }
}
