//
//  Node.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift

final class Node: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var parent: Node?
    @Persisted var children: RealmSwift.List<Node>
    @Persisted var name: String
    
    convenience init(parent: Node? = nil, children: RealmSwift.List<Node>, name: String) {
        self.init()
        self.parent = parent
        self.children = children
        self.name = name
    }
}
