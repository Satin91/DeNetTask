//
//  StorageManager.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift
import SwiftUI

final class StorageManager {
    @ObservedResults(Node.self) var realmObjects
    var storagePublisher = CurrentValueSubject<Node, Never>(Node())
    private var cancelBag = Set<AnyCancellable>()
    
    private let userDefaults = UserDefaults()
    
    init() {
        createStorageIfNeed()
    }
    
    func save(_ path: Path) {
        userDefaults.set(path, forKey: "Path")
    }
    
    func loadPath() -> Path {
        let path = userDefaults.object(forKey: "Path") as? Path ?? Path()
        return path
    }
    
    private func createStorageIfNeed() {
        if realmObjects.isEmpty {
            let rootFolder = Node(children: RealmSwift.List<Node>(), name: "Root")
            let explorerFolder = Node(parent: rootFolder, children: RealmSwift.List<Node>(), name: "Explorer")
            rootFolder.children.append(explorerFolder)
            storagePublisher.send(rootFolder)
            $realmObjects.append(rootFolder)
        } else {
            guard let storage = realmObjects.first else {
                fatalError("Storage not found")
            }
            storagePublisher.send(storage)
        }
    }
}
