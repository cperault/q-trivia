//
//  NetworkEnforcement.swift
//  Q-Trivia
//
//  Created by Christopher Perault on 2/1/23.
//

import Foundation
import Network

final class NetworkEnforcement: ObservableObject {
    private let networkEnforcement = NWPathMonitor()
        private let workerQueue = DispatchQueue(label: "Monitor")
        var isConnected = false

        init() {
            networkEnforcement.pathUpdateHandler = { path in
                self.isConnected = path.status == .satisfied
                Task {
                    await MainActor.run {
                        self.objectWillChange.send()
                    }
                }
            }
            networkEnforcement.start(queue: workerQueue)
        }
}
