//
//  ContentView.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var gameValues: GameValues = GameValues()

    var body: some View {
        NavigationStack {
            MainView()
                .environment(\.managedObjectContext, viewContext)
                .environmentObject(gameValues)
        }
    }
}
