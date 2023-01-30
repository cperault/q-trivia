//
//  EndGameButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct EndGameButtonview: View {
    var buttonAction: () -> Void
    var buttonIcon: String
    
    var body: some View {
        Button(action: buttonAction, label: {
            HStack(spacing: 8) {
                Image(systemName: buttonIcon)
                    .modifier(QuestionViewEndGameButtonViewImageModifier())
            }
            .modifier(QuestionViewEndGameButtonViewHStackModifier())
        })
    }
}
