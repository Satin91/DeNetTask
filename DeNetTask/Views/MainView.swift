//
//  MainView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewViewModel
    private let appendButtonSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    @State var nodes = [Node]()
    
    var body: some View {
        content
            .onReceive(viewModel.currentNode) { output in
                self.nodes = output.children
            }
    }
    
    private var content: some View {
        VStack {
            arrowBack
            tabView
            appendButton
        }
        .background {
            Color(Colors.background)
        }
    }
    
    var tabView: some View {
        NodeView(
            nodes: nodes,
            onTap: { index in viewModel.follow(to: index) },
            onDelete: { _ in }
        )
    }
    
    var appendButton: some View {
        Button {
            viewModel.saveNewNode()
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
    
    var arrowBack: some View {
        HStack {
            Image(systemName: "arrow.backward")
                .font(.body.weight(.bold))
                .foregroundColor(Color.red)
                .frame(width: 20, height: 20, alignment: .leading)
            Spacer()
        }
        .padding()
        .onTapGesture {
            viewModel.back()
        }
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel())
    }
}
