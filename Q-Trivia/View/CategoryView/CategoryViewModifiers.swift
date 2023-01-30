//
//  CategoryViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct CategoryButtonViewModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
    }
}

struct CategoryListBackgroundModifier: ViewModifier {
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

struct RandomCategoryButtonViewHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
    }
}

struct RandomCategoryButtonViewImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}
