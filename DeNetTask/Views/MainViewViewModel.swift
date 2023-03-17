//
//  MainViewViewModel.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Combine
import Foundation

final class MainViewViewModel: ObservableObject {
    // storage for the whole tree
    var root = Node(parent: nil, name: "Root", children: [])
    // before the eyes
    var currentNode = CurrentValueSubject<Node, Never>(Node(children: []))
    
    private var cancelBag = Set<AnyCancellable>()
    
    var path = [Int]()
    
    var isHomeScreen: Bool {
        path.isEmpty
    }
    
    init() {
        subscribes()
    }
    
    private func subscribes() {
        currentNode.sink { _ in
            print("path \(self.path)")
        }
        .store(in: &cancelBag)
    }
    
    func getCurrentNode() {
        var temporary: Node = root
        path.forEach { index in
            if temporary.children.indices.contains(index) {
                temporary = temporary.children[index]
            } else {
                // for debugging
                fatalError("Node not found")
            }
        }
        currentNode.send(temporary)
    }
    
    // MARK: - Navigation
    func follow(to: Int) {
        if currentNode.value.children.indices.contains(to) {
            currentNode.send(currentNode.value.children[to])
            path.append(to)
        } else {
            // for debugging
            fatalError("Node not found")
        }
    }
    
    func back() {
        path.removeLast()
        if let parent = currentNode.value.parent {
            currentNode.send(parent)
        } else {
            currentNode.send(root)
        }
    }
    
    // MARK: - 'Storage'
    func addNode() {
        if path.isEmpty {
            let newNode = Node(parent: root, name: "root", children: [])
            root.children.append(newNode)
            currentNode.send(root)
        } else {
            let newNode = Node(parent: currentNode.value, name: "not root", children: [] )
            let node = findNodeByPath()
            node.children.append(newNode)
            currentNode.send(node)
        }
    }
    
    func remove(by: Int) {
        let node = findNodeByPath()
        if node.children.indices.contains(by) {
            node.children.remove(at: by)
            currentNode.send(node)
        }
    }
}

extension MainViewViewModel {
    private func findNodeByPath() -> Node {
        var temporary = root
        for index in path where temporary.children.indices.contains(index) {
            let node = temporary.children[index]
            temporary = node
        }
        return temporary
    }
}
