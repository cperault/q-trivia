//
//  ScoreboardViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/29/23.
//

import SwiftUI

struct ScoreboardHomeButtonViewHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct ScoreboardHomeButtonViewHStackTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
    }
}

struct ScoreboardHomeButtonViewHStackImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct ScoreboardViewListBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

struct ScoreboardViewDetailsButtonHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)    }
}

struct ScoreboardViewDetailsButtonHStackTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
    }
}

struct ScoreboardViewDetailsButtonImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct ScoreboardViewDeleteScoresButtonHStackTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.semibold)
    }
}

struct ScoreboardViewDeleteScoresButtonImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct ScoreboardViewDeleteScoresButtonHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)    }
}
