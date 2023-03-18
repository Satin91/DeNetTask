//
//  DeNetTaskApp.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import SwiftUI

@main
struct DeNetTaskApp: App {
    let navigator = Navigation()
    
    var body: some Scene {
        WindowGroup {
            ExplorerView()
                .environmentObject(navigator)
        }
    }
}
