//
//  MainViewViewModel.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import Combine
import Foundation

class MainViewViewModel: ObservableObject {
    // storage for the whole tree
    private var root = Node(name: "Root", parent: nil, children: [])
    // before the eyes
    var currentNode = CurrentValueSubject<Node, Never>(Node(children: []))
    
    private var subscribe = Set<AnyCancellable>()
    
    private var path = [Int]()
    
    var isHomeScreen: Bool {
        path.isEmpty
    }
    
    init() {
    }
    
    private func subscribes() {
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
        if let parent = currentNode.value.parent {
            currentNode.send(parent)
            path.removeLast()
        } else {
            currentNode.send(root)
        }
    }
    
    // MARK: - Storage
    func saveNewNode() {
        if path.isEmpty {
            let newNode = Node(name: "root", parent: root, children: [] )
            root.children.append(newNode)
            currentNode.send(root)
        } else {
            let newNode = Node(name: "no root", parent: currentNode.value.parent, children: [] )
            let node = findTheNode()
            node.children.append(newNode)
            currentNode.send(node)
        }
    }
    
    func remove(by: Int) {
        let node = findTheNode()
        if node.children.indices.contains(by) {
            node.children.remove(at: by)
            currentNode.send(node)
        }
    }
}
// Root
// Current
// Back
// Follow

// Methods:
// Add
// Delete

// Storage:
// Load
// Save

extension MainViewViewModel {
    private func findTheNode() -> Node {
        var temporary = root
        for index in path where temporary.children.indices.contains(index) {
            let node = temporary.children[index]
            temporary = node
        }
        return temporary
    }
}
