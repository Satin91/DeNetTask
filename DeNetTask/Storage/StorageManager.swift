//
//  StorageManager.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift

final class StorageManager {
    @ObservedResults(NodeRealm.self) var realmObjects
    
    var storagePublisher = CurrentValueSubject<NodeRealm, Never>(NodeRealm())
    
    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        createStorageIfNeed()
    }
    
    func addNode(at path: Path) {
        let currentNode = findNodeBy(path: path)
        realmTransactor {
            let nodeRealm = NodeRealm(parent: currentNode, children: List<NodeRealm>(), name: "")
            let name = "\(nodeRealm.hashValue)".suffix(5)
            nodeRealm.name = String(name)
            currentNode.children.append(nodeRealm)
        }
        storagePublisher.send(currentNode)
    }
    
    func removeNode(at path: Path, with index: Int) {
        let node = findNodeBy(path: path)
        if node.children.indices.contains(index) {
            realmTransactor {
                node.children.remove(at: index)
                refreshPublisher()
            }
        }
    }
    
    private func createStorageIfNeed() {
        if realmObjects.isEmpty {
            let rootFolder = NodeRealm(children: RealmSwift.List<NodeRealm>(), name: "Explorer")
            $realmObjects.append(rootFolder)
        } else {
            guard let storage = realmObjects.first else {
                fatalError("Storage not found")
            }
            storagePublisher.send(storage)
        }
    }
}

private func realmTransactor(handler: () -> Void) {
    do {
        let realm = try Realm()
        try realm.write {
            handler()
        }
    } catch let error {
        print("Error write transaction \(error.localizedDescription)")
    }
}

extension StorageManager {
    private func findNodeBy(path: Path) -> NodeRealm {
        var temporary = storagePublisher.value
        for index in path where temporary.children.indices.contains(index) {
            let node = temporary.children[index]
            temporary = node
        }
        return temporary
    }
    
    private func refreshPublisher() {
        storagePublisher.send(storagePublisher.value)
    }
}
