//
//  SettingsViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct SettingsViewButtonIconModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct SettingsViewButtonHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}
