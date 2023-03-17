//
//  Node.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Foundation

class Node: Decodable {
    var parent: Node?
    var children: [Node]
    var name: String?

    init(parent: Node? = nil, name: String? = nil, children: [Node]) {
        self.parent = parent
        self.children = children
        self.name = name
    }
}
