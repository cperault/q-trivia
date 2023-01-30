//
//  MultiplayerViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct MultiplayerViewTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.heavy)
    }
}

struct MultiplayerViewTextFieldModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct MultiplayerViewHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
    }
}

struct MultiplayerViewVStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding()
    }
}

struct MultiplayerViewImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct MultiplayerViewHStackImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .foregroundColor(Color.primary)
    }
}

struct MultiplayerViewNextButtonHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct MultiplayerViewNextButtonHStackTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
    }
}

struct MultiplayerViewNextButtonHStackImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}


