//
//  Item.swift
//  Todoey
//
//  Created by Egbert-Jan Terpstra on 30/08/2018.
//  Copyright © 2018 Egbert-Jan Terpstra. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
//    @objc dynamic var date_created : Date = Date.init()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
