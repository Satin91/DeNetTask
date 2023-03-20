//
//  ExplorerView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct ExplorerView: View {
    private let appendButtonSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    @EnvironmentObject var navigator: Navigation
    @State var nodes = [NodeRealm]()
    @State var address = ""
    
    var body: some View {
        content
            .onReceive(navigator.currentFolder) { node in
                nodes = Array(node.children)
            }
    }
    
    private var content: some View {
        VStack(spacing: 26) {
            navigationBar
            foldersView
        }
        .background(Color(Colors.background))
    }
    
    var navigationBar: some View {
        HStack {
            backButton
            addressBar
            addButton
        }
        .frame(width: Sizes.screenWidth)
    }
    
    var addButton: some View {
        NavBarButton(type: .add) {
            navigator.addFolder()
        }
    }
    
    var backButton: some View {
        HStack {
            NavBarButton(type: .back) {
                navigator.back()
            }
        }
        .opacity(navigator.isRootScreen ? 0 : 1)
    }
    
    var addressBar: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color.gray.opacity(0.1))
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .overlay {
                Text(navigator.address)
                    .foregroundColor(Color(Colors.accentColor))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
    }
    
    var foldersView: some View {
        FoldersView(
            nodes: nodes,
            onTap: { index in navigator.openFolder(at: index) },
            onDelete: { index in navigator.removeFolder(at: index) }
        )
    }
}
