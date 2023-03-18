//
//  FoldersView.swift
//  DeNetTask
//
//  Created by Артур Кулик on 14.03.2023.
//

import RealmSwift
import SwiftUI

struct FoldersView: View {
    var nodes: [NodeRealm]
    var onTap: (Int) -> Void
    var onDelete: (Int) -> Void
    
    var body: some View {
        content
    }
    
    var content: some View {
        list
    }
    
    var list: some View {
        List {
            ForEach(0..<nodes.count, id: \.self) { index in
                NodeListView(text: Array(nodes)[index].name, onDelete: { onDelete(index) })
                    .onTapGesture {
                        onTap(index)
                    }
                    .listRowBackground(Color(Colors.background))
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
                    deleteButton
                        .padding(.trailing)
                }
            }
    }
    
    private var deleteButton: some View {
        Image(systemName: "xmark")
            .font(.body.weight(.medium))
            .foregroundColor(Color(Colors.accentColor))
            .onTapGesture {
                onDelete()
            }
    }
    
    private var rectangle: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color(Colors.rowBackground))
            .frame(height: 60)
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
