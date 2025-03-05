//
//  FormSubmissionManager.swift
//  GatorScout
//
//  Created by Ayda Gokturk on 2/26/25.
//


import Foundation

class FormSubmissionManager: ObservableObject {
    static let shared = FormSubmissionManager()
    @Published var savedForms: [[String: Any]] = []

    private init() {
        loadSavedForms()
    }

    func submitData(_ formData: [String: Any]) {
        if NetworkMonitor.shared.isConnected {
            sendDataToServer(formData)
        } else {
            saveFormDataLocally(formData)
        }
    }

    private func sendDataToServer(_ formData: [String: Any]) {
        let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbxEQTuiZFZHwCLFx7hFvdEEXaYK5H6m-Ae3hzyBFhErH-44T7o61XQyqEUV61myt0X9/exec")!
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: formData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding data.")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    print("Data submitted successfully!")
                } else {
                    print("Submission failed, saving locally.")
                    self.saveFormDataLocally(formData)
                }
            }
        }
        task.resume()
    }

    private func saveFormDataLocally(_ formData: [String: Any]) {
        if var existingForms = UserDefaults.standard.array(forKey: "savedForms") as? [[String: Any]] {
            existingForms.append(formData)
            UserDefaults.standard.set(existingForms, forKey: "savedForms")
        } else {
            UserDefaults.standard.set([formData], forKey: "savedForms")
        }
    }

    private func loadSavedForms() {
        if let savedForms = UserDefaults.standard.array(forKey: "savedForms") as? [[String: Any]] {
            self.savedForms = savedForms
        }
    }

    func resubmitSavedForms() {
        loadSavedForms()
        guard NetworkMonitor.shared.isConnected else { return }

        for (index, formData) in savedForms.enumerated().reversed() {
            sendDataToServer(formData)
            savedForms.remove(at: index)
        }

        UserDefaults.standard.set(savedForms, forKey: "savedForms")
    }
}
