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
