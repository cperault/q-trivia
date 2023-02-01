//
//  Q_TriviaApp.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 1/28/23.
//

import SwiftUI

@main
struct Q_TriviaApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var networkEnforcement = NetworkEnforcement()

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(networkEnforcement)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
