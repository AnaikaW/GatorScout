import SwiftUI
import Foundation

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

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
    static let darkGreenFont = Color(hex: "#006400")
}

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
    @State private var allianceColor = "Red"

    // State for pin location
    @State private var pinLocation: CGPoint? = nil
    @State private var imageSize: CGSize = .zero

    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            
            ZStack {
                Color.greenTheme1.edgesIgnoringSafeArea(.all)
                    .edgesIgnoringSafeArea(.all)
                                    .onTapGesture {
                                        UIApplication.shared.endEditing()
                                    }
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

                        Section(header: Text("Alliance Color and Scouting").foregroundColor(.darkGreenFont)) {
                            Picker("Alliance", selection: $allianceColor) {
                                Text("Red").tag("Red")
                                Text("Blue").tag("Blue")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical, 8)
                            
                            VStack {
                                Text("Tap to mark the robot's starting position.")
                                    .font(.subheadline)
                                    .foregroundColor(.darkGreenFont)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 5)

                                GeometryReader { geometry in
                                    ZStack {
                                        Image("1700")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                            .clipped()
                                            .overlay(
                                                allianceColor == "Red"
                                                    ? Image("1700")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geometry.size.width * 2, height: geometry.size.height)
                                                        .offset(x: geometry.size.width / 2, y: 0)
                                                    : Image("1700")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geometry.size.width * 2, height: geometry.size.height)
                                                        .offset(x: -geometry.size.width / 2, y: 0)
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
                                            .overlay(
                                                pinLocation.map { location in
                                                    Circle()
                                                        .fill(Color.greenTheme2)
                                                        .frame(width: 20, height: 20)
                                                        .position(location)
                                                }
                                            )
                                    }
                                }
                                .frame(height: 300)
                            }
                            .padding()

                        }


                        Section(header: Text("Performance").foregroundColor(.darkGreenFont)) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Auto Points:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoPoints) {
                                        ForEach(0..<31) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 100, height: 120)
                                    .clipped()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                }
                                .padding(.vertical, 4)
                            }


                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Teleop Points:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopPoints) {
                                        ForEach(0..<31) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 100, height: 120)
                                    .clipped()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                }
                                .padding(.vertical, 4)
                            }
                                
                               
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("End Game Points:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("End Game Points", selection: $endGamePoints) {
                                        ForEach(0..<31) { number in
                                            Text("\(number)").tag(number)
                                        }
                                    }
                                    .pickerStyle(WheelPickerStyle())
                                    .frame(width: 100, height: 120)
                                    .clipped()
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .foregroundColor(.darkGreenFont)
                                }
                                .padding(.vertical, 4)
                            }

                            Toggle("Offense", isOn: $isOffense)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)
                            Toggle("Defense", isOn: $isDefense)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)

                            VStack(alignment: .leading) {
                                Text("Driving Score: \(Int(drivingScore))")
                                    .font(.headline)
                                    .foregroundColor(.darkGreenFont)
                                    .padding(.bottom, 4)

                                Slider(value: $drivingScore, in: 1...10, step: 1)
                                    .accentColor(.greenTheme2)
                                    .padding(.bottom, 4)

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
                                    .frame(height: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.darkGreenFont, lineWidth: 1)
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
        guard !teamNumber.isEmpty else {
            alertMessage = "Team Number is required."
            showErrorAlert = true
            return
        }
        
        guard !matchNumber.isEmpty else {
            alertMessage = "Match Number is required."
            showErrorAlert = true
            return
        }
    
        guard drivingScore > 0 else {
            alertMessage = "Driving Score must be selected."
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
            "Alliance": allianceColor,
            "Auto Points": autoPoints,
            "Teleop Points": teleopPoints,
            "End Game Points": endGamePoints,
            "Offense": isOffense ? "Yes" : "No",
            "Defense": isDefense ? "Yes" : "No",
            "Driving Score": Int(drivingScore)
        ]
        
        if !comments.isEmpty {
            formData["Comments"] = comments
        }

        if let pinLocation = pinLocation {
            let normalizedX = ((pinLocation.x / imageSize.width) - 0.5) * 2
            let normalizedY = ((1 - (pinLocation.y / imageSize.height)) - 0.5) * 2
            let fieldX = normalizedX * 917 / 2
            let fieldY = normalizedY * 466 / 2
            formData["Field Coordinates"] = ["x": fieldX, "y": fieldY]
        }

        let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbztu6xHmQ1hhbqcQjCCVCL2zrS9Sc-tYPH17alxR8uw7Zbm_kEvxwGpMqgExJxRIm9pZg/exec")!
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
