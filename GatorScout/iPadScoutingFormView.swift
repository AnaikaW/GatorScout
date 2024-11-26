import SwiftUI

struct iPadScoutingFormView: View {
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

    @State private var allianceColor = "Red"
    @State private var pinLocation: CGPoint? = nil
    @State private var imageSize: CGSize = .zero

    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                matchInfoSection
                allianceColorSection
                performanceSection
                commentsSection
                submitButton
            }
            .scrollContentBackground(.hidden)
            .background(Color.greenTheme1)
            .navigationBarTitle("Team 1700 Scouting", displayMode: .inline)
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
        .navigationViewStyle(StackNavigationViewStyle()) 
        .background(Color.greenTheme1.edgesIgnoringSafeArea(.all))
    }

    var matchInfoSection: some View {
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
    }
    
    var allianceColorSection: some View {
        Section(header: Text("Alliance Color and Scouting").foregroundColor(.darkGreenFont)) {
            Picker("Alliance", selection: $allianceColor) {
                Text("Red").tag("Red")
                Text("Blue").tag("Blue")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, 8)

            GeometryReader { geometry in
                ZStack {
                    Image("1700")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width * 2, height: 800)
                        .offset(x: allianceColor == "Red" ? 0 : -geometry.size.width)
                        .clipped()
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
                            pinLocation.map {
                                Circle()
                                    .fill(Color.greenTheme2)
                                    .frame(width: 50, height: 50)
                                    .position($0)
                            }
                        )
                }
            }
            .frame(height: 800)
        }
    }

    var performanceSection: some View {
        Section(header: Text("Performance").foregroundColor(.darkGreenFont)) {
            HStack {
                Text("Auto Points:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("", selection: $autoPoints) {
                    ForEach(0..<31) { Text("\($0)").tag($0) }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 200)
            }
            HStack {
                Text("Teleop Points:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("", selection: $teleopPoints) {
                    ForEach(0..<31) { Text("\($0)").tag($0) }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 200)
            }
            HStack {
                Text("End Game Points:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("", selection: $endGamePoints) {
                    ForEach(0..<31) { Text("\($0)").tag($0) }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: 200)
            }
            VStack(alignment: .leading) {
                        Text("Driving Score: \(Int(drivingScore))")
                            .font(.headline)
                            .foregroundColor(.darkGreenFont)

                        Slider(value: $drivingScore, in: 1...10, step: 1)
                            .accentColor(.greenTheme2)

                        Text(descriptionForScore(Int(drivingScore)))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)

                    VStack(alignment: .leading) {
                        Toggle("Offense", isOn: $isOffense)
                            .foregroundColor(.darkGreenFont)
                            .font(.headline)

                        Toggle("Defense", isOn: $isDefense)
                            .foregroundColor(.darkGreenFont)
                            .font(.headline)
                    }
                    .padding(.top, 10)
        }
    }


    var commentsSection: some View {
        Section(header: Text("Comments").foregroundColor(.darkGreenFont)) {
            TextEditor(text: $comments)
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .foregroundColor(.darkGreenFont)
                .frame(height: 150)
        }
    }

    var submitButton: some View {
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
            let fieldX = normalizedX * 9.17 / 2
            let fieldY = normalizedY * 4.66 / 2
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


struct iPadScoutingFormView_Previews: PreviewProvider {
    static var previews: some View {
        iPadScoutingFormView(username: "PreviewUser")
            .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    }
}
