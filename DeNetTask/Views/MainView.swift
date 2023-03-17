//
//  MainView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct MainView: View {
    private let appendButtonSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    @StateObject var viewModel: MainViewViewModel
    @State var nodes = [Node]()
    @State var isAnimate = false
    
    var body: some View {
        content
            .onReceive(viewModel.currentNode) { Node in
                nodes = Node.children
                isAnimate.toggle()
            }
    }
    
    private var content: some View {
        VStack {
            backButton
            rowsView
            appendButton
        }
        .background(Color(Colors.background))
    }
    
    var rowsView: some View {
        RowsView(
            nodes: nodes,
            onTap: { index in viewModel.follow(to: index) },
            onDelete: { index in viewModel.remove(by: index) }
        )
        .animation(.easeIn(duration: 0.3), value: isAnimate)
    }
    
    var appendButton: some View {
        Button {
            viewModel.addNode()
        } label: {
            Text("Append")
                .foregroundColor(.white)
                .background(
                    Color(Colors.accentColor)
                        .frame(width: appendButtonSize.width, height: appendButtonSize.height)
                )
                .frame(width: appendButtonSize.width, height: appendButtonSize.height)
                .cornerRadius(16)
        }
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
            viewModel.back()
        }
        .opacity(viewModel.isHomeScreen ? 0 : 1)
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel())
    }
}
