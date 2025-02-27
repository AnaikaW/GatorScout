import SwiftUI
import Foundation

struct ScoutingFormView: View {
    let username: String

    @State private var teamNumber = ""
    @State private var matchNumber = ""
    @State private var isSubmitting = false

    @State private var leaveStartingLine = false
    @State private var autoCoralL1 = 0
    @State private var autoCoralL2 = 0
    @State private var autoCoralL3 = 0
    @State private var autoCoralL4 = 0
    @State private var autoAlgaeRemoved = 0

    @State private var teleopCoralL1 = 0
    @State private var teleopCoralL2 = 0
    @State private var teleopCoralL3 = 0
    @State private var teleopCoralL4 = 0
    @State private var teleopAlgaeRemoved = 0
    @State private var algaeScoredNet = 0
    @State private var algaeScoredProcessor = 0

    @State private var didDeepCage = false
    @State private var didShallowCage = false
    @State private var isParked = false

    @State private var comments = ""

    @State private var isOffense = false
    @State private var isDefense = false

    @State private var drivingScore: Double = 0.0

    // Alliance selection
    @State private var allianceColor = "Red"

    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    
    @State private var savedForms: [[String: Any]] = []


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
                        }
                        
                        Section(header: Text("Auto").foregroundColor(.darkGreenFont)) {
                            Toggle("Robot left starting line?", isOn: $leaveStartingLine)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Auto coral scored in level 1 (trough):")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoCoralL1) {
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
                                    Text("Auto coral scored in level 2:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoCoralL2) {
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
                                    Text("Auto coral scored in level 3:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoCoralL3) {
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
                                    Text("Auto coral scored in level 4:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoCoralL4) {
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
                                    Text("Auto algae removed from reef:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Auto Points", selection: $autoAlgaeRemoved) {
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
                            
                        }
                        
                        Section(header: Text("Teleop").foregroundColor(.darkGreenFont)) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Teleop coral scored in level 1 (trough):")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopCoralL1) {
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
                                    Text("Teleop coral scored in level 2:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopCoralL2) {
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
                                    Text("Teleop coral scored in level 3:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopCoralL3) {
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
                                    Text("Teleop coral scored in level 4:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopCoralL4) {
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
                                    Text("Teleop algae removed from reef:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $teleopAlgaeRemoved) {
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
                                    Text("Algae scored into net:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $algaeScoredNet) {
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
                                    Text("Algae scored into processor:")
                                        .font(.headline)
                                        .foregroundColor(.darkGreenFont)
                                        .padding(.trailing, 8)
                                    Spacer()
                                    Picker("Teleop Points", selection: $algaeScoredProcessor) {
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
                        }
                        
                        Section(header: Text("Endgame").foregroundColor(.darkGreenFont)) {
                            Toggle("Robot is parked?", isOn: $isParked)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)
                            Toggle("Is robot successfully hanging from shallow cage?", isOn: $didShallowCage)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)
                            Toggle("Is robot successfully hanging from deep cage?", isOn: $didDeepCage)
                                .foregroundColor(.darkGreenFont)
                                .font(.headline)
                        }
                        
                        Section(header: Text("Performance").foregroundColor(.darkGreenFont)) {

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

                                Slider(value: $drivingScore, in: 0...10, step: 1)
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

        guard drivingScore > -1 else {
            alertMessage = "Driving Score must be selected."
            showErrorAlert = true
            return
        }

        isSubmitting = true

        var formData: [String: Any] = [
            "Username": username,
            "Team Number": teamNumber,
            "Match Number": matchNumber,
            "Alliance": allianceColor,
            "Left starting line": leaveStartingLine ? "Yes" : "No",
            "Auto Coral L1": autoCoralL1,
            "Auto Coral L2": autoCoralL2,
            "Auto Coral L3": autoCoralL3,
            "Auto Coral L4": autoCoralL4,
            "Auto Algae Removed": autoAlgaeRemoved,
            "Teleop Coral L1": teleopCoralL1,
            "Teleop Coral L2": teleopCoralL2,
            "Teleop Coral L3": teleopCoralL3,
            "Teleop Coral L4": teleopCoralL4,
            "Teleop Algae Removed": teleopAlgaeRemoved,
            "Algae Scored Net": algaeScoredNet,
            "Algae Scored Processor": algaeScoredProcessor,
            "Robot parked": isParked ? "Yes" : "No",
            "Shallow Cage": didShallowCage ? "Yes" : "No",
            "Deep cage": didDeepCage ? "Yes" : "No",
            "Offense": isOffense ? "Yes" : "No",
            "Defense": isDefense ? "Yes" : "No",
            "Driving Score": Int(drivingScore)
        ]

        if !comments.isEmpty {
            formData["Comments"] = comments
        }

        // Call FormSubmissionManager to handle online/offline submission
        FormSubmissionManager.shared.submitData(formData)

        isSubmitting = false
        alertMessage = "Data queued for submission."
        showSuccessAlert = true
    }
    
        func saveFormDataLocally(_ formData: [String: Any]) {
            if var existingForms = UserDefaults.standard.array(forKey: "savedForms") as? [[String: Any]] {
                existingForms.append(formData)
                UserDefaults.standard.set(existingForms, forKey: "savedForms")
            } else {
                UserDefaults.standard.set([formData], forKey: "savedForms")
            }
        }

        func loadSavedForms() {
            if let savedForms = UserDefaults.standard.array(forKey: "savedForms") as? [[String: Any]] {
                self.savedForms = savedForms
            }
        }

        func submitSavedForm(formData: [String: Any], index: Int) {
            let endpointURL = URL(string: "https://script.google.com/macros/s/AKfycbztu6xHmQ1hhbqcQjCCVCL2zrS9Sc-tYPH17alxR8uw7Zbm_kEvxwGpMqgExJxRIm9pZg/exec")!
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: formData, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error encoding saved data.")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        self.savedForms.remove(at: index)
                        UserDefaults.standard.set(self.savedForms, forKey: "savedForms")
                    } else {
                        print("resubmit failed for one form")
                    }
                }
            }
            task.resume()
        }

    


    func clearFields() {
        teamNumber = ""
        matchNumber = ""
        //Auto
        leaveStartingLine = false
        autoCoralL1 = 0
        autoCoralL2 = 0
        autoCoralL3 = 0
        autoCoralL4 = 0
        autoAlgaeRemoved = 0
        
        teleopCoralL1 = 0
        teleopCoralL2 = 0
        teleopCoralL3 = 0
        teleopCoralL4 = 0
        teleopAlgaeRemoved = 0
        algaeScoredNet = 0
        algaeScoredProcessor = 0
        
        isParked = false
        didShallowCage = false
        didDeepCage = false

        
        comments = ""
        isOffense = false
        isDefense = false
        drivingScore = 0.0
        allianceColor = "Red"
    }
    func descriptionForScore(_ score: Int) -> String {
        switch score {
        case 0: return "0 = No driving at all"
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
