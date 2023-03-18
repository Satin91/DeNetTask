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
    @State var isAnimate = false
    
    var body: some View {
        content
            .onReceive(navigator.currentFolder) { node in
                nodes = Array(node.children)
            }
        //            .onReceive(viewModel.currentNode) { Node in
        //                nodes = Node.children
        //                isAnimate.toggle()
        //            }
    }
    
    private var content: some View {
        VStack {
            addressBar
            backButton
            rowsView
            appendButton
        }
        .background(Color(Colors.background))
    }
    
    var addressBar: some View {
        Text(navigator.address)
            .foregroundColor(Color(Colors.accentColor))
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding()
            .frame(width: Size.screenSize)
            .background(Color.black)
    }
    
    var rowsView: some View {
        FoldersView(
            nodes: nodes,
            onTap: { index in navigator.openFolder(at: index) },
            onDelete: { index in navigator.removeFolder(at: index) }
        )
        .animation(.easeIn(duration: 0.3), value: isAnimate)
    }
    
    var appendButton: some View {
        Button {
            navigator.addFolder()
        } label: {
            Text("New Folder")
                .foregroundColor(Color(Colors.accentColor))
        }
        .frame(width: Size.screenSize)
        .padding(.top)
        .padding()
        .background(Color.black)
    }
    
    var backButton: some View {
        HStack {
            Image(systemName: "arrow.backward")
                .font(.body.weight(.bold))
                .foregroundColor(Color(Colors.accentColor))
                .frame(width: 20, height: 20, alignment: .leading)
            Spacer()
        }
        .padding()
        .onTapGesture {
            navigator.back()
        }
        .opacity(navigator.isRootScreen ? 0 : 1)
    }
}
