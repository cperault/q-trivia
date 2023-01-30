//
//  SettingsButtonView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct SettingsButtonView: View {
    @State private var isViewingSettings: Bool = false
    @EnvironmentObject var gameValues: GameValues
    
    var body: some View {
        VStack {
            Button(action: {
                isViewingSettings = true
            }, label: {
                HStack(spacing: 8) {
                    Image(systemName: "gearshape")
                        .modifier(SettingsViewButtonIconModifier())
                }
                .modifier(SettingsViewButtonHStackModifier())
            })
        }
        .navigationDestination(isPresented: $isViewingSettings) {
            SettingsView()
                .environmentObject(gameValues)
        }
    }
}
