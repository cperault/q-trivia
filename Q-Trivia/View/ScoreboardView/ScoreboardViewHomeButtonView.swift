//
//  ScoreboardViewHomeButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct ScoreboardViewHomeButtonView: View {
    var buttonAction: () -> Void
    var buttonText: String?
    var buttonIcon: String?
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(spacing: 8) {
                if let buttonText {
                    Text(buttonText)
                        .modifier(ScoreboardHomeButtonViewHStackTextModifier())
                }
                if let buttonIcon {
                    Image(systemName: buttonIcon)
                        .modifier(ScoreboardHomeButtonViewHStackImageModifier())
                }
            }
            .modifier(ScoreboardHomeButtonViewHStackModifier())
        })
    }
}
