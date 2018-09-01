//
//  Category.swift
//  Todoey
//
//  Created by Egbert-Jan Terpstra on 30/08/2018.
//  Copyright © 2018 Egbert-Jan Terpstra. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
