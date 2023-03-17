//
//  MainView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewViewModel
    private let appendButtonSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    @State var nodes = [Node]()
    @State var isAnimate = false
    
    var body: some View {
        content
            .onReceive(viewModel.currentNode) { output in
                self.nodes = output.children
                isAnimate.toggle()
            }
    }
    
    private var content: some View {
        VStack {
            arrowBack
            nodeView
            appendButton
        }
        .background(Color(Colors.background))
    }
    
    var nodeView: some View {
        NodeView(
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
        .opacity(viewModel.isHomeScreen ? 0 : 1)
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel())
    }
}
