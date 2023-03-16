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
    var currentNode = CurrentValueSubject<Node, Never>(Node(children: [Node(children: [])]))
    
    private var subscribe = Set<AnyCancellable>()
    
    private var path = [0]
    
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
                fatalError("Node not found")
            }
        }
        currentNode.send(temporary)
    }
    
    func follow(to: Int) {
        if currentNode.value.children.indices.contains(to) {
            currentNode.send(currentNode.value.children[to])
        } else {
            fatalError("Node not found")
        }
    }
    
    func back() {
        if let parent = currentNode.value.parent {
            currentNode.send(parent)
        } else {
            fatalError("Parent not found")
        }
    }
    
    // MARK: - Storage
    func saveNewNode() {
        var temporary = root
        print(root.children.count)
        for index in path {
            if let node = temporary.children[index] {
                temporary = node
            }
        }
        print(currentNode.value.children)
        currentNode.send(temporary)
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
