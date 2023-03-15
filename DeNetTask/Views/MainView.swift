//
//  MainView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewViewModel
    @State var pageIndex = 1
    private let appendButtonSize = CGSize(
        width: UIScreen.main.bounds.width - 32,
        height: 40
    )
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack {
            tabView
            appendButton
        }
    }
    
    var tabView: some View {
        TabView {
            ForEach(0..<pageIndex, id: \.self) { _ in
                VStack {
                    NodeView(nodes: viewModel.root.children) { _ in
                        pageIndex += 1
                    }
                }
            }
        }
        .tabViewStyle(.page)
        .tag(pageIndex)
    }
    
    var appendButton: some View {
        ZStack {
            Button {
                viewModel.addChild(node: &viewModel.root)
            } label: {
                Text("Append")
                    .foregroundColor(.white)
                    .background(
                        Color.red
                            .frame(width: appendButtonSize.width, height: appendButtonSize.height)
                    )
                    .frame(width: appendButtonSize.width, height: appendButtonSize.height)
                    .cornerRadius(16)
            }
        }
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel())
    }
}
