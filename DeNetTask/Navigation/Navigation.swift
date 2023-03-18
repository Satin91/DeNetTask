//
//  Navigation.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift

class Navigation: ObservableObject {
    // Properties
    var currentFolder = CurrentValueSubject<NodeRealm, Never>(NodeRealm())
    private let storage = StorageManager()
    private var cancelBag = Set<AnyCancellable>()
    
    private var path = Path()
    
    var isRootScreen: Bool {
        path.isEmpty
    }
    
    var address: String {
        getAddress()
    }
    
    init() {
        subscribeToStorage()
    }
    
    private func subscribeToStorage() {
        storage.storagePublisher.sink { node in
            self.currentFolder.send(node)
        }
        .store(in: &cancelBag)
    }
    
    // MARK: Storage
    func addFolder() {
        storage.addNode(at: path)
    }
    
    func removeFolder(at index: Int) {
        storage.removeNode(at: path, with: index)
    }
    
    func openFolder(at: Int) {
        if currentFolder.value.children.indices.contains(at) {
            currentFolder.send(currentFolder.value.children[at])
            path.append(at)
        } else {
            // for debugging
            fatalError("Node not found")
        }
    }
    
    func back() {
        path.removeLast()
        if let parent = currentFolder.value.parent {
            currentFolder.send(parent)
        }
    }
    
    private func getAddress() -> String {
        var temporary = currentFolder.value
        var address: [String] = []
        path.forEach { _ in
            address.append(temporary.parent?.name ?? "")
            temporary = temporary.parent!
        }
        let oneLine = address.reversed().joined(separator: "/")
        return oneLine
    }
}
