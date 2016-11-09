//
//  User+CoreDataClass.swift
//  
//
//  Created by Jordan Stapinski on 11/5/16.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }
    
    @NSManaged public var username: String?
    @NSManaged public var stripe: Stripe?
}
