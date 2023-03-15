//
//  DeNetTaskApp.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import SwiftUI

@main
struct DeNetTaskApp: App {
    let viewModel = MainViewViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: viewModel)
        }
    }
}
