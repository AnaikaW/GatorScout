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

    @Published var isConnected: Bool = false

    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                let wasOffline = !self.isConnected
                self.isConnected = path.status == .satisfied

                // If we were offline and now we're online, trigger resubmission
                if wasOffline && self.isConnected {
                    print("Network restored! Resubmitting saved forms...")
                    FormSubmissionManager.shared.resubmitSavedForms()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
