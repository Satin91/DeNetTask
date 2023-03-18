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
    
    func addNode() {
        realmTransactor {
            let nodeRealm = NodeRealm(children: List<NodeRealm>(), name: "Name1")
            storagePublisher.value.children.append(nodeRealm)
        }
        refresh()
        print("Storage childrens \(Array(storagePublisher.value.children).map({ $0.name }))")
    }
    
    func removeNode(at path: Path, with index: Int) {
        let node = findNodeBy(path: path)
        if node.children.indices.contains(index) {
            realmTransactor {
                node.children.remove(at: index)
                refresh()
            }
        }
    }
    
    private func createStorageIfNeed() {
        if realmObjects.isEmpty {
            $realmObjects.append(NodeRealm())
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
    
    private func refresh() {
        storagePublisher.send(storagePublisher.value)
    }
}
