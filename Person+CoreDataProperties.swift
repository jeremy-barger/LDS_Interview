//
//  Person+CoreDataProperties.swift
//  LDS_Interview
//
//  Created by Jeremy Barger on 12/17/19.
//  Copyright © 2019 Jeremy Barger. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var birthDate: String?
    @NSManaged public var profilePic: String?
    @NSManaged public var forceSensitive: Bool
    @NSManaged public var affiliation: String?
    @NSManaged public var id: Int16

}
