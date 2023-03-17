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
        tableView
    }
    
    var tableView: some View {
        List {
            ForEach(0..<nodes.count, id: \.self) { index in
                NodeListView(text: nodes[index].name ?? "No name", onDelete: { onDelete(index) })
                    .onTapGesture {
                        onTap(index)
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct NodeListView: View {
    var text: String
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
            .font(.body.weight(.medium))
            .foregroundColor(Color(Colors.accentColor))
            .onTapGesture {
                onDelete()
            }
    }
    
    private var rectangle: some View {
        RoundedRectangle(cornerRadius: 14)
            .foregroundColor(Color(Colors.rowBackground))
            .frame(height: 60)
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
