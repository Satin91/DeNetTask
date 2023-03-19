//
//  FoldersView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import SwiftUI

struct FoldersView: View {
    var nodes: [NodeRealm]
    var onTap: (Int) -> Void
    var onDelete: (Int) -> Void
    @State var isAnimate = false
    
    var columns: [GridItem] = [
        GridItem(.fixed(Sizes.screenWidth / 3), spacing: 0),
        GridItem(.fixed(Sizes.screenWidth / 3), spacing: 0),
        GridItem(.fixed(Sizes.screenWidth / 3), spacing: 0)
    ]
    
    var body: some View {
        content
    }
    
    var content: some View {
        list
    }
    
    var list: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<nodes.count, id: \.self) { index in
                    NodeListView(text: Array(nodes)[index].name, onDelete: { onDelete(index) })
                        .onTapGesture {
                            onTap(index)
                            isAnimate.toggle()
                        }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct NodeListView: View {
    var text: String
    let onDelete: () -> Void
    
    var body: some View {
        content
    }
    
    private var content: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                title
                Spacer(minLength: .zero)
                deleteButton
            }
            .padding(.horizontal, 24)
            folderImage
        }
    }
    
    private var title: some View {
        Text(text)
            .font(.callout)
            .foregroundColor(.white.opacity(0.8))
    }
    
    private var deleteButton: some View {
        Image(systemName: "trash.circle.fill")
            .font(.body.weight(.medium))
            .foregroundColor(Color(Colors.accentColor))
            .onTapGesture {
                onDelete()
            }
    }
    
    private var folderImage: some View {
        Image(Images.folder)
            .resizable()
            .scaledToFill()
            .frame(width: 80, height: 80)
    }
}
