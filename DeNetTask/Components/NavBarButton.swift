//
//  NavBarButton.swift
//  DeNetTask
//
//  Created by Артур Кулик on 19.03.2023.
//

import SwiftUI

enum ActionType {
    case add
    case back
}

struct NavBarButton: View {
    var type: ActionType
    var action: () -> Void
    
    private var imageName: String {
        switch type {
        case .add:
            return "plus"
        case .back:
            return "arrow.backward"
        }
    }
    var body: some View {
        button
    }
    
    private var button: some View {
        Image(systemName: imageName)
            .font(.body.weight(.bold))
            .foregroundColor(Color(Colors.accentColor))
            .padding()
            .onTapGesture {
                action()
            }
    }
}

struct NavBarButton_Previews: PreviewProvider {
    static var previews: some View {
        NavBarButton(type: .add, action: {})
    }
}
