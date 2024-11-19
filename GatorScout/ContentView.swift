import SwiftUI
import Foundation

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
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(.darkGreenFont)
                configuration.label
                    .foregroundColor(.darkGreenFont)
            }
        })
    }
}

import SwiftUI

struct ScoutingFormView: View {
    let username: String // Username passed from LoginView

    @State private var teamNumber = ""
    @State private var matchNumber = ""
    @State private var isSubmitting = false
    
    @State private var autoPoints = ""
    @State private var teleopPoints = ""
    @State private var endGamePoints = ""
    @State private var comments = ""
    
    @State private var isOffense = false
    @State private var isDefense = false
    
    @State private var drivingScore: Double = 0.0 // Default slider value
    @State private var alliance = "Red" // Default to Red Alliance
    
    // State for pin location
    @State private var pinLocation: CGPoint? = nil
    @State private var imageSize: CGSize = .zero // Store image size to normalize coordinates
    
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.greenTheme1.edgesIgnoringSafeArea(.all)
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
                        
                        Section(header: Text("Alliance").foregroundColor(.darkGreencolor)) {
                            VStack {
                                // Instructions for the user
                                Text("Press on the screen to mark the starting point of the robot.")
                                    .font(.subheadline)
                                    .foregroundColor(.darkGreenFont)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 5)
                                
                                // Picker for Alliance Selection
                                Picker("Select Alliance", selection: $alliance) {
                                    Text("Red").tag("Red")
                                    Text("Blue").tag("Blue")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding()
                                
                                // Image with gesture to drop a pin
                                GeometryReader { geometry in
                                    ZStack {
                                        if alliance == "Red" {
                                            Image("red_alliance") // Replace with Red Alliance image name
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                                .overlay(
                                                    // Draw a pin if location is set
                                                    pinLocation.map { location in
                                                        Circle()
                                                            .fill(Color.red)
                                                            .frame(width: 20, height: 20)
                                                            .position(location)
                                                    }
                                                )
                                                .gesture(
                                                    // Capture tap location
                                                    DragGesture(minimumDistance: 0)
                                                        .onEnded { value in
                                                            let location = value.location
                                                            if location.x >= 0 && location.x <= geometry.size.width &&
                                                                location.y >= 0 && location.y <= geometry.size.height {
                                                                pinLocation = location
                                                                imageSize = geometry.size
                                                            }
                                                        }
                                                )
                                        } else {
                                            Image("blue_alliance") // Replace with Blue Alliance image name
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 300)
                                                .overlay(
                                                    // Draw a pin if location is set
                                                    pinLocation.map { location in
                                                        Circle()
                                                            .fill(Color.blue)
                                                            .frame(width: 20, height: 20)
                                                            .position(location)
                                                    }
                                                )
                                                .gesture(
                                                    // Capture tap location
                                                    DragGesture(minimumDistance: 0)
                                                        .onEnded { value in
                                                            let location = value.location
                                                            if location.x >= 0 && location.x <= geometry.size.width &&
                                                                location.y >= 0 && location.y <= geometry.size.height {
                                                                pinLocation = location
                                                                imageSize = geometry.size
                                                            }
                                                        }
                                                )
                                        }
                                    }
                                }
                                .frame(height: 300)
                            }
                            .padding()
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
                            
                            VStack {
                                Text("Driving Performance: \(Int(drivingScore))")
                                    .foregroundColor(.darkGreenFont)
                                
                                Slider(value: $drivingScore, in: 1...10, step: 1)
                                    .accentColor(.greenTheme2)
                            }
                            .padding()
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
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
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

        // Normalize pin location to percentage of the image size
        let normalizedPinLocation: [String: CGFloat]? = pinLocation.map {
            ["x": $0.x / imageSize.width, "y": $0.y / imageSize.height]
        }
        
        var formData: [String: Any] = [
            "Username": username,
            "Team Number": teamNumber,
            "Match Number": matchNumber,
            "Alliance": alliance,
            "Auto Points": autoPoints,
            "Teleop Points": teleopPoints,
            "End Game Points": endGamePoints,
            "Comments": comments,
            "Offense": isOffense ? "Yes" : "No",
            "Defense": isDefense ? "Yes" : "No",
            "Driving Score": Int(drivingScore)
        ]
        
        if let pinData = normalizedPinLocation {
            formData["Pin Location"] = pinData
        }
        
        // Submit formData to your backend
        let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbwAcrK6Ld2DyoKI61d8SCSCkdirPCqZz3I-BNiWDxUfkdJtM60nw-HMkZ0Y71CR6rs/exec")! // Replace with your endpoint
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
        drivingScore = 0.0
        alliance = "Red" // Reset to default
        pinLocation = nil // Clear pin
    }
}

