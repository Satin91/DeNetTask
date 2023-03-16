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
    
    var nodeObjects = CurrentValueSubject<[Node], Never>([Node(parent: Node(parent: nil, children: []), children: [])])
    
    var cancelBag = Set<AnyCancellable>()
    var path = CurrentValueSubject<[Int], Never>([0])
    
    init() {
        subscribe()
    }
    
    func addChild(node: inout Node) {
        let currentNode = currentNode(for: path.value)
        let newNode = Node(name: "\(root.children.count)", parent: currentNode.parent, children: [])
        currentNode.children.append(newNode)
    }
    
    func removeChild(index: Int) {
        let currentNode = currentNode(for: path.value)
        currentNode.children.remove(at: index)
        self.nodeObjects.send(nodeObjects.value)
        print("remove child")
    }
    
    func subscribe() {
        path.sink { [weak self] newPath in
            guard let self else { return }
            self.nodeObjects.send(self.getCurrentNodes(for: newPath))
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
        for (order, index) in path.enumerated() {
            if order == 0 {
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
        for (order, index) in path.enumerated() {
            if order == 0 {
                node = root
            } else {
                node = node.children[index]
            }
        }
        return node
    }
}
