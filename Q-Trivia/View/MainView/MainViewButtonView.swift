//
//  MainViewButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct MainViewButtonView: View {
    var buttonAction: () -> Void
    var buttonText: String?
    var buttonIcon: String?

    var body: some View {
        Button(action: buttonAction, label: {
            HStack(spacing: 8) {
                if let buttonText {
                    Text(buttonText)
                        .modifier(MainViewButtonTextModifier())
                }
                if let buttonIcon {
                    Image(systemName: buttonIcon)
                        .modifier(MainViewButtonIconModifier())
                }
            }
            .modifier(MainViewButtonHStackModifier())
        })
    }
}
