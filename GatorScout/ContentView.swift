import SwiftUI
import Foundation

// Hex color extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Color themes
extension Color {
    static let greenTheme1 = Color(hex: "#9beba4")
    static let greenTheme2 = Color(hex: "#32a840")
    static let greenTheme3 = Color(hex: "#32a840")
    static let darkGreenFont = Color(hex: "#006400")
    static let darkGreencolor = Color(hex: "#162417")
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            // Toggle the state when the button is pressed
            configuration.isOn.toggle()
        }, label: {
            HStack {
                // Display a checkmark if the toggle is on, else an empty square
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(.darkGreenFont) // Customize the color of the checkbox icon
                configuration.label
                    .foregroundColor(.darkGreenFont) // Customize the label text color
            }
        })
    }
}

struct ScoutingFormView: View {
    @State private var teamNumber = ""
    @State private var matchNumber = ""
    @State private var isSubmitting = false
    
    // New variables for additional performance data
    @State private var autoPoints = ""
    @State private var teleopPoints = ""
    @State private var endGamePoints = ""
    @State private var comments = ""
    
    // Variables for offense and defense toggles
    @State private var isOffense = false
    @State private var isDefense = false
    
    // Alert variables
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.greenTheme1.edgesIgnoringSafeArea(.all) // Main green background
                VStack {
                    Form {
                        Section(header: Text("Match Information").foregroundColor(.darkGreencolor)) {
                            TextField("Team Number", text: $teamNumber)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            
                            TextField("Match Number", text: $matchNumber)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                        }
                        
                        Section(header: Text("Performance").foregroundColor(.darkGreencolor)) {
                            TextField("Auto Points", text: $autoPoints)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            
                            TextField("Teleop Points", text: $teleopPoints)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            
                            TextField("End Game Points", text: $endGamePoints)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            
                            TextField("Comments", text: $comments)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            
                            Toggle("Offense", isOn: $isOffense)
                                .toggleStyle(iOSCheckboxToggleStyle())
                            
                            Toggle("Defense", isOn: $isDefense)
                                .toggleStyle(iOSCheckboxToggleStyle())
                        }
                        
                        Section {
                            Button(action: submitData) {
                                if isSubmitting {
                                    ProgressView()
                                } else {
                                    Text("Submit")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.greenTheme2)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.greenTheme1)
                }
                .padding()
            }
            .navigationBarTitle("FRC Scouting", displayMode: .inline)
            .foregroundColor(.white)
            .accentColor(Color.greenTheme2)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("title") // Replace with the name of your image asset
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40) // Adjust height as needed
                }
            }
            // Error Alert
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            // Success Alert
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Log Another Match"), action: clearFields)
                )
            }
        }
    }

    func submitData() {
        guard !teamNumber.isEmpty, !matchNumber.isEmpty else {
            alertMessage = "All fields must be filled."
            showErrorAlert = true
            return
        }

        isSubmitting = true

        let formData: [String: Any] = [
            "Team Number": teamNumber,
            "Match Number": matchNumber,
            "Auto Points": autoPoints,
            "Teleop Points": teleopPoints,
            "End Game Points": endGamePoints,
            "Comments": comments,
            "Offense": isOffense ? "Yes" : "No",
            "Defense": isDefense ? "Yes" : "No"
        ]

        let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbz0LdNSmki3z9tRTv3qoQ7J2ZVQk2RoMX1g3xc4AWxk_Lp_17LIRcR3u7Ns8cALYtA9ag/exec")!

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: formData, options: [])
            request.httpBody = jsonData
        } catch {
            alertMessage = "Unable to encode data."
            showErrorAlert = true
            isSubmitting = false
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false

                if let error = error {
                    alertMessage = "Error: \(error.localizedDescription)"
                    showErrorAlert = true
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    alertMessage = "Failed to submit data."
                    showErrorAlert = true
                    return
                }

                alertMessage = "Data submitted successfully!"
                showSuccessAlert = true
            }
        }
        task.resume()
    }

    func clearFields() {
        teamNumber = ""
        matchNumber = ""
        autoPoints = ""
        teleopPoints = ""
        endGamePoints = ""
        comments = ""
        isOffense = false
        isDefense = false
    }
}
