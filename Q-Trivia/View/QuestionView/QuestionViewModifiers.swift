//
//  QuestionViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct QuestionViewEndGameButtonViewHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
    }
}

struct QuestionViewEndGameButtonViewImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}
