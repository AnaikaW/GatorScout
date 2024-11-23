import SwiftUI
import Foundation

// Color and helper extensions
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

// Custom Colors
extension Color {
    static let greenTheme1 = Color(hex: "#9beba4")
    static let greenTheme2 = Color(hex: "#32a840")
    static let darkGreenFont = Color(hex: "#006400")
}

// View structure
struct ScoutingFormView: View {
    let username: String

    @State private var teamNumber = ""
    @State private var matchNumber = ""
    @State private var isSubmitting = false

    @State private var autoPoints = 0
    @State private var teleopPoints = 0
    @State private var endGamePoints = 0
    @State private var comments = ""

    @State private var isOffense = false
    @State private var isDefense = false

    @State private var drivingScore: Double = 0.0

    // Alliance selection
    @State private var allianceColor = "Red" // Default to Red Alliance

    // State for pin location
    @State private var pinLocation: CGPoint? = nil
    @State private var imageSize: CGSize = .zero // Store image size for normalization

    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.greenTheme1.edgesIgnoringSafeArea(.all)
                VStack {
                    Form {
                        Section(header: Text("Match Information").foregroundColor(.darkGreenFont)) {
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

                        Section(header: Text("Alliance Color").foregroundColor(.darkGreenFont)) {
                            Picker("Alliance", selection: $allianceColor) {
                                Text("Red").tag("Red")
                                Text("Blue").tag("Blue")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                        }

                        Section(header: Text("Alliance Map").foregroundColor(.darkGreenFont)) {
                            VStack {
                                Text("Tap to mark the robot's starting position.")
                                    .font(.subheadline)
                                    .foregroundColor(.darkGreenFont)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 5)

                                GeometryReader { geometry in
                                    ZStack {
                                        Image("1700") // Background map image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 300)
                                            .overlay(
                                                pinLocation.map { location in
                                                    Circle()
                                                        .fill(Color.greenTheme2)
                                                        .frame(width: 20, height: 20)
                                                        .position(location)
                                                }
                                            )
                                            .gesture(
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
                                .frame(height: 300)
                            }
                            .padding()
                        }

                        Section(header: Text("Performance").foregroundColor(.darkGreenFont)) {
                            VStack(alignment: .leading) {
                                Text("Auto Points")
                                    .font(.headline) // Adjust font as needed
                                    .foregroundColor(.darkGreenFont) // Same color as your picker for consistency
                                    .padding(.bottom, 4) // Adds spacing between title and picker
                                
                                Picker("Auto Points", selection: $autoPoints) {
                                    ForEach(0..<31) { number in // Adjust the range as needed
                                        Text("\(number)").tag(number)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle()) // Use a wheel picker for scrolling
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(8)
                                .foregroundColor(.darkGreenFont)
                            }

                            VStack(alignment: .leading, spacing: 16) { // Adjust spacing as needed
                                // Teleop Points Picker
                                VStack(alignment: .leading) {
                                    Text("Teleop Points")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.bottom, 4)
                                    
                                    Picker("Teleop Points", selection: $teleopPoints) {
                                        ForEach(0..<31) { number in // Adjust the range as needed
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                }
                                
                                // End Game Points Picker
                                VStack(alignment: .leading) {
                                    Text("End Game Points")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.bottom, 4)
                                    
                                    Picker("End Game Points", selection: $endGamePoints) {
                                        ForEach(0..<11) { number in // Adjust the range as needed
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                }
                            }

                            Toggle("Offense", isOn: $isOffense)
                            Toggle("Defense", isOn: $isDefense)

                            VStack(alignment: .leading) {
                                Text("Driving Score: \(Int(drivingScore))")
                                    .font(.headline)
                                    .foregroundColor(.darkGreenFont)
                                    .padding(.bottom, 4)

                                Slider(value: $drivingScore, in: 1...10, step: 1)
                                    .accentColor(.greenTheme2)
                                    .padding(.bottom, 4)

                                // Dynamic description for the driving score
                                Text(descriptionForScore(Int(drivingScore)))
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Comments")
                                    .font(.headline)
                                    .foregroundColor(.darkGreenFont)
                                    .padding(.bottom, 4)

                                TextEditor(text: $comments)
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                    .frame(height: 150) // Set a height for the TextEditor
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.darkGreenFont, lineWidth: 1) // Optional border for better visibility
                                    )
                            }
                            .padding(.vertical)
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

        let normalizedPinLocation: [String: CGFloat]? = pinLocation.map {
            ["x": $0.x / imageSize.width, "y": $0.y / imageSize.height]
        }

        var formData: [String: Any] = [
            "Username": username,
            "Team Number": teamNumber,
            "Match Number": matchNumber,
            "Alliance": allianceColor, // Log alliance color
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
        
        let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbx5RRLJUkuxSnlfXQnmtI8O2J78M_mJE4VrU66z_ufw8GhrIYEJICYjZ67iunJQxU-olQ/exec")!
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
        autoPoints = 0
        teleopPoints = 0
        endGamePoints = 0
        comments = ""
        isOffense = false
        isDefense = false
        drivingScore = 0.0
        pinLocation = nil
        allianceColor = "Red"
    }
    func descriptionForScore(_ score: Int) -> String {
        switch score {
        case 1: return "1 = Poor driving performance"
        case 2: return "2 = Below average driving"
        case 3: return "3 = Somewhat effective driving"
        case 4: return "4 = Slightly below average performance"
        case 5: return "5 = Average driving ability"
        case 6: return "6 = Above average driving"
        case 7: return "7 = Good driving performance"
        case 8: return "8 = Very good driving skills"
        case 9: return "9 = Excellent driving performance"
        case 10: return "10 = Outstanding driving ability"
        default: return "Score out of range"
        }
    }

}
