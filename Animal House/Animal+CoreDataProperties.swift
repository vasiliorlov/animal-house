//
//  Animal+CoreDataProperties.swift
//  
//
//  Created by iMac on 01.07.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Animal {

    @NSManaged var linkPhoto: String?
    @NSManaged var name: String?
    @NSManaged var sector: String?
    @NSManaged var tit: String?
    @NSManaged var typeNote: NSNumber?
    @NSManaged var photo: NSData?

}
