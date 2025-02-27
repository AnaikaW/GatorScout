//
//  NetworkMonitor.swift
//  GatorScout
//
//  Created by Ayda Gokturk on 2/26/25.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global(qos: .background)

    @Published var isConnected: Bool = true

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                if self.isConnected {
                    FormSubmissionManager.shared.resubmitSavedForms()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
