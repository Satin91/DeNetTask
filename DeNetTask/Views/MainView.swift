//
//  MainView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 15.03.2023.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: MainViewViewModel
    @State var pageIndex = 0
    @State var isAnimate = false
    private let appendButtonSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 60)
    @State var pageChanged = false
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack {
            arrowBack
            tabView
            appendButton
        }
    }
    
    var tabView: some View {
        TabView(selection: $pageIndex) {
            ForEach(0..<pageIndex + 1, id: \.self) { index in
                VStack {
                    NodeView(
                        nodes: viewModel.root.children,
                        onTap: { page in
                            self.pageIndex += 1
                            self.isAnimate.toggle()
                            viewModel.path.value.append(page)
                        }, onDelete: { index in
                            viewModel.removeChild(index: index)
                        }
                    )
                    .contentShape(Rectangle())
                    .gesture(DragGesture())
                    .tag(index)
                }
            }
        }
        .tabViewStyle(.page)
        .animation(.easeInOut(duration: 0.3), value: isAnimate)
    }
    
    var arrows: some View {
        EmptyView()
    }
    
    var appendButton: some View {
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
    
    var arrowBack: some View {
        HStack {
            Image(systemName: "arrow.backward")
                .font(.body.weight(.bold))
                .foregroundColor(Color.red)
                .frame(width: 20, height: 20, alignment: .leading)
                .opacity(pageIndex == 0 ? 0 : 1)
            Spacer()
        }
        .padding()
        .onTapGesture {
            pageIndex -= 1
            viewModel.path.value.removeLast()
        }
    }
}

struct ViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewViewModel())
    }
}
