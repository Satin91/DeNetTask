//
//  Navigation.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation
import RealmSwift

typealias Path = [Int]

class Navigation: ObservableObject {
    var currentFolder = CurrentValueSubject<NodeRealm, Never>(NodeRealm())
    private var storage = CurrentValueSubject<NodeRealm, Never>(NodeRealm())
    private var cancelBag = Set<AnyCancellable>()
    
    private let storageManager = StorageManager()
    
    private var path = Path() {
        didSet {
            storageManager.save(path)
        }
    }
    
    var isRootScreen: Bool {
        path.isEmpty
    }
    
    var address: String {
        getAddress()
    }
    
    init() {
        loadPath()
        subscribeToStorage()
    }
    
    private func loadPath() {
        path = storageManager.loadPath()
    }
    
    private func subscribeToStorage() {
        storageManager.storagePublisher.sink { node in
            self.storage.send(node)
            let currentFolder = self.findNodeBy(path: self.path)
            self.currentFolder.send(currentFolder)
        }
        .store(in: &cancelBag)
    }
    
    func addFolder() {
        realmTransactor {
            let newFolder = NodeRealm(parent: self.currentFolder.value, children: RealmSwift.List<NodeRealm>(), name: "")
            let folderName = "\(abs(newFolder.hashValue))".prefix(5)
            newFolder.name = String(folderName)
            self.currentFolder.value.children.append(newFolder)
        } completion: {
            self.currentFolder.refresh()
        }
    }
    
    func removeFolder(at index: Int) {
        realmTransactor {
            self.currentFolder.value.children.remove(at: index)
        } completion: {
            self.currentFolder.refresh()
        }
    }
    
    func openFolder(at index: Int) {
        currentFolder.send(currentFolder.value.children[index])
        path.append(index)
    }
    
    func back() {
        if let parent = currentFolder.value.parent {
            currentFolder.send(parent)
            path.removeLast()
        }
    }
    
    private func getAddress() -> String {
        var temporary: NodeRealm? = currentFolder.value
        var address: [String] = []
        path.forEach { _ in
            address.append(temporary?.name ?? "Root")
            temporary = temporary?.parent
        }
        let joinedLine = address.reversed().joined(separator: "/")
        return joinedLine
    }
    
    private func findNodeBy(path: Path) -> NodeRealm {
        var temporary = storage.value
        for index in path {
            let node = temporary.children[index]
            temporary = node
        }
        return temporary
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
}
