import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @State private var isPhoneMode = true // Default to phone mode

    let correctPassword = "gogators"
    
    var body: some View {
        Group {
            if isLoggedIn {
                if isPhoneMode {
                    ScoutingFormView(username: username) // Phone view
                } else {
                    iPadScoutingFormView(username: username) // iPad-specific view
                }
            } else {
                ZStack {
                    Color.greenTheme1.edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        Text("Login")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.darkGreenFont)
                        
                        TextField("Username", text: $username)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .foregroundColor(.darkGreenFont)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .foregroundColor(.darkGreenFont)
                        
                        Toggle("Use Phone Mode", isOn: $isPhoneMode)
                            .padding()
                            .foregroundColor(.darkGreenFont)
                        
                        Button(action: validateLogin) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.greenTheme2)
                                .cornerRadius(10)
                        }
                        .padding(.top, 20)
                    }
                    .padding()
                    .alert(isPresented: $showErrorAlert) {
                        Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
    
    func validateLogin() {
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields."
            showErrorAlert = true
            return
        }
        
        if password == correctPassword {
            isLoggedIn = true
        } else {
            alertMessage = "Incorrect password. Please try again."
            showErrorAlert = true
        }
    }
}
