//
//  MainViewViewModel.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Foundation

class MainViewViewModel: ObservableObject {
    @Published var root = Node(parent: Node(parent: Node(parent: nil, children: []), children: []), children: [])
    @Published var index: [Int] = [0]
    
    func addChild(node: inout Node) {
        let newNode = Node(name: "\(root.children.count)", parent: root, children: [])
        root.children.append(newNode)
    }
}
