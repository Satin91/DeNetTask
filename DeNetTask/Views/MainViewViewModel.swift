//
//  MainViewViewModel.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Combine
import Foundation

class MainViewViewModel: ObservableObject {
    @Published var root = Node(parent: Node(parent: Node(parent: nil, children: []), children: []), children: [])
    
    var currentNodeObject = CurrentValueSubject<Node, Never>(Node(parent: Node(parent: nil, children: []), children: []))
    
    var cancelBag = Set<AnyCancellable>()
    var path = CurrentValueSubject<[Int], Never>([0])
    
    init() {
        subscribe()
    }
    
    func addChild(node: inout Node) {
        let newNode = Node(name: "\(root.children.count)", parent: root, children: [])
        currentNode(for: path.value).children.append(newNode)
    }
    
    func subscribe() {
        path.sink { [weak self] newPath in
            guard let self else { return }
            self.currentNodeObject.send(self.currentNode(for: newPath))
        }
        .store(in: &cancelBag)
    }
    
    func currentNode(for path: [Int]) -> Node {
        var node = root
        for index in path {
            if index == 0 {
                node = root
            } else {
                node = node.children[index]
            }
        }
        return node
    }
}
