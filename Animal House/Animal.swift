//
//  Animal.swift
//  
//
//  Created by iMac on 01.07.16.
//
//

import Foundation
import RealmSwift
class Animal: Object{
    dynamic var linkPhoto: String?
    dynamic var name: String?
    dynamic var sector: String?
    dynamic var tit: String?
    dynamic var typeNote:Int = -1
    dynamic var photo: NSData?
    
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
}

