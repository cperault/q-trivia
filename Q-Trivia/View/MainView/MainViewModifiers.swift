//
//  MainViewModifiers.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct MainViewBackgroundModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            //.background(Color(UIColor(red:0.49, green:0.76, blue:0.79, alpha:1.0))) //r: 126, g: 193, b: 201
            .background(Color.lightOrDarkMode)
    }
}

struct MainViewTitleModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .font(.largeTitle)
                .fontWeight(.heavy)
        } else {
            content
                .font(.largeTitle)
        }
    }
}

struct MainViewImageModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .cornerRadius(15)
    }
}

struct MainViewButtonTextModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 16, *) {
            content
                .font(.title)
                .fontWeight(.semibold)
        } else {
            content
                .font(.title)
        }
    }
}

struct MainViewButtonIconModifier: ImageModifier {
    func body(image: Image) -> some View {
        image
            .imageScale(.large)
    }
}

struct MainViewButtonHStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct MainViewZStackModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
    }
}
