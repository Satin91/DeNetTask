//
//  NodeView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import SwiftUI

struct NodeView: View {
    var nodes: [Node]
    var onTap: (Int) -> Void
    var onDelete: (Int) -> Void
    
    var body: some View {
        content
    }
    
    var content: some View {
        VStack {
            tableView
        }
    }
    
    var tableView: some View {
        List {
            ForEach(0..<nodes.count, id: \.self) { index in
                NodeListView(text: nodes[index].name ?? "No name", onDelete: { onDelete(index) })
                    .onTapGesture {
                        onTap(index)
                    }
                    .listRowBackground(Color(Colors.background))
            }
            .listRowSeparator(.hidden)
        }.listStyle(.plain)
    }
}

struct NodeListView: View {
    var text: String
    let height: CGFloat = 40
    let cornerRadius: CGFloat = 14
    let onDelete: () -> Void
    
    var body: some View {
        content
    }
    
    private var content: some View {
        rectangle
            .overlay {
                HStack {
                    Spacer()
                    xMarkImage
                        .padding(.trailing)
                }
            }
    }
    
    private var xMarkImage: some View {
        Image(systemName: "xmark")
            .font(.body.weight(.light))
            .foregroundColor(Color(Colors.font))
            .onTapGesture {
                onDelete()
            }
    }
    
    private var rectangle: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(Color(Colors.items))
            .frame(height: height)
            .overlay {
                HStack {
                    Text(text)
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding()
                    Spacer()
                }
            }
    }
}
