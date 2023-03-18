//
//  Navigation.swift
//  DeNetTask
//
//  Created by Артур Кулик on 18.03.2023.
//

import Combine
import Foundation

class Navigation: ObservableObject {
    // Properties
    var currentFolder = CurrentValueSubject<NodeRealm, Never>(NodeRealm())
    private let storage = StorageManager()
    private var cancelBag = Set<AnyCancellable>()
    
    private var path = Path()
    
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
        storage.addNode()
    }
    
    func removeFolder(at index: Int) {
        storage.removeNode(at: path, with: index)
    }
    
    // Add folder
    // Remove folder
    
    // Follow
    // Back
}
