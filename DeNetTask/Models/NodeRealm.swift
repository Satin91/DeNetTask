//
//  NodeRealm.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift

final class NodeRealm: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var parent: NodeRealm?
    @Persisted var children: RealmSwift.List<NodeRealm>
    @Persisted var name: String
    
    convenience init(parent: NodeRealm? = nil, children: RealmSwift.List<NodeRealm>, name: String) {
        self.init()
        self.parent = parent
        self.children = children
        self.name = name
    }
}
