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
    
    var currentNodeObject = CurrentValueSubject<[Node], Never>([Node(parent: Node(parent: nil, children: []), children: [])])
    
    var current: Node {
        currentNode(for: path.value)
    }
    
    var cancelBag = Set<AnyCancellable>()
    var path = CurrentValueSubject<[Int], Never>([0])
    
    init() {
        subscribe()
    }
    
    func addChild(node: inout Node) {
        let newNode = Node(name: "\(root.children.count)", parent: current.parent, children: [])
        currentNode(for: path.value).children.append(newNode)
    }
    
    func subscribe() {
        path.sink { [weak self] newPath in
            guard let self else { return }
            self.currentNodeObject.send(self.getCurrentNodes(for: newPath))
        }
        .store(in: &cancelBag)
    }
    
    func saveToStorage() {
        DispatchQueue.global(qos: .background).async {
            // MARK: Save path
            // MARK: Save root
        }
    }
    
    func saveNodeForPath() {
    }
    
    func getCurrentNodes(for path: [Int]) -> [Node] {
        var nodes: [Node] = []
        var tmpRoot = root
        for index in path {
            if index == 0 {
                nodes = [root]
            } else {
                let iterationNode = tmpRoot.children[index]
                nodes.append(iterationNode)
                tmpRoot = iterationNode
            }
        }
        return nodes
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
        print(#function)
        return node
    }
}
