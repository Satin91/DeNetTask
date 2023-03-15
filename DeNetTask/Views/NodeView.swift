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
                NodeListView(text: nodes[index].name ?? "No name")
                    .onTapGesture {
                        print("Tap index \(index)")
                        onTap(index)
                    }
            }
            .onDelete(perform: { _ in
            })
            .listRowSeparator(.hidden)
        }.listStyle(.plain)
    }
}

struct NodeListView: View {
    var text: String
    let height: CGFloat = 40
    let cornerRadius: CGFloat = 14
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(.blue)
            .shadow(color: .gray, radius: 6)
            .frame(height: height)
            .overlay {
                HStack {
                    Text(text)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(alignment: .leading)
                        .padding()
                    Spacer()
                }
            }
    }
}
