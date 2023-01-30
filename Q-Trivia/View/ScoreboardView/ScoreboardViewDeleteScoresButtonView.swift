//
//  ScoreboardViewDeleteScoresButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct ScoreboardViewDeleteScoresButtonView: View {
    var buttonAction: () -> Void
    var buttonText: String?
    var buttonIcon: String?
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(spacing: 8) {
                if let buttonText {
                    Text(buttonText)
                        .modifier(ScoreboardViewDeleteScoresButtonHStackTextModifier())
                }
                if let buttonIcon {
                    Image(systemName: buttonIcon)
                        .modifier(ScoreboardViewDeleteScoresButtonImageModifier())
                }
            }
            .modifier(ScoreboardViewDeleteScoresButtonHStackModifier())
        })
    }
}
