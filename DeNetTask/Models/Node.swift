//
//  Node.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Foundation

class Node {
    var name: String?
    var parent: Node?
    var children: [Node]
    
    init(name: String? = nil, parent: Node? = nil, children: [Node]) {
        self.parent = parent
        self.children = children
        self.name = name
    }
}
