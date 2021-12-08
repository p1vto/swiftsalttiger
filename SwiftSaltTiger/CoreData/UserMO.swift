//
//  UserMO.swift
//  SwiftSaltTiger
//
//  Created by p1vtoMiilo on 8/12/2021.
//

import CoreData
import SwiftUI

public class UserMO: NSManagedObject {}

// MARK: - Properties
extension UserMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMO> {
        NSFetchRequest<UserMO>(entityName: "UserMO")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var email: String?
}


extension UserMO: ManagedObjectProtocol {
    func toEntity() -> User {
        User(name: name ?? "User",
             email: email ?? "unknown@gmail.com")
    }
}

extension User: ManagedObjectConvertible {
    
    @discardableResult
    func toManagedObject(in context: NSManagedObjectContext) -> UserMO {
        let userMO = UserMO(context: context)
        userMO.name = name
        userMO.email = email
        return userMO
    }
}
