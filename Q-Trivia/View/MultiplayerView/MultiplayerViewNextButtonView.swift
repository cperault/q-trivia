//
//  MultiplayerViewNextButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct MultiplayerViewNextButtonView: View {
    var buttonAction: () -> Void
    var buttonText: String?
    var buttonIcon: String?
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(spacing: 8) {
                if let buttonText {
                    Text(buttonText)
                        .modifier(MultiplayerViewNextButtonHStackTextModifier())
                }
                if let buttonIcon {
                    Image(systemName: buttonIcon)
                        .modifier(MultiplayerViewHStackImageModifier())
                }
            }
            .modifier(MultiplayerViewHStackModifier())
        })
    }
}
