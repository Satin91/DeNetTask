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
    
    func addNode(to node: NodeRealm) {
        realmTransactor {
            let nodeRealm = NodeRealm(parent: node, children: List<NodeRealm>(), name: "")
            let name = "\(nodeRealm.hashValue)".suffix(5)
            nodeRealm.name = String(name)
            node.children.append(nodeRealm)
        } completion: {
            storagePublisher.send(node)
        }
    }
    
    func removeNode(from node: NodeRealm, at index: Int) {
        realmTransactor {
            node.children.remove(at: index)
        } completion: {
            storagePublisher.send(node)
        }
    }
    
    private func createStorageIfNeed() {
        if realmObjects.isEmpty {
            let rootFolder = NodeRealm(children: RealmSwift.List<NodeRealm>(), name: "Root")
            let explorerFolder = NodeRealm(parent: rootFolder, children: RealmSwift.List<NodeRealm>(), name: "Explorer")
            rootFolder.children.append(explorerFolder)
            $realmObjects.append(rootFolder)
        } else {
            guard let storage = realmObjects.first else {
                fatalError("Storage not found")
            }
            storagePublisher.send(storage)
        }
    }
}

private func realmTransactor(handler: @escaping () -> Void, completion: () -> Void) {
    do {
        let realm = try Realm()
        try realm.write {
            handler()
        }
    } catch let error {
        print("Error write transaction \(error.localizedDescription)")
    }
    completion()
}

extension StorageManager {
    private func findNodeBy(path: Path) -> NodeRealm {
        var temporary = storagePublisher.value
        print("Debug: Path index \(path)")
        for index in path {
            print("Debug: Iteration index \(index)")
            let node = temporary.children[index]
            temporary = node
        }
        return temporary
    }
    
    private func refreshPublisher() {
        storagePublisher.send(storagePublisher.value)
    }
}
