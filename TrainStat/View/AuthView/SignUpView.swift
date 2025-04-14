//
//  SignUpView.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/20/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var onSkip: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                AuthHeaderView(title: "Welcome!", onSkip: onSkip)
                
                Text("Please, sign up or login")
                    .foregroundColor(.white)
                
                AuthTextField(title: "Email", placeholder: "Enter your email address", isSecure: false, text: $email)
                AuthTextField(title: "Password", placeholder: "Enter your password", isSecure: true, text: $password)
                AuthTextField(title: "Confirm Password", placeholder: "Re-enter your password", isSecure: true, text: $confirmPassword)
                
                Button(action: {
                    Task {
                        await signUp()
                    }
                }) {
                    Text("Sign up")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(5)
                }
                .padding(.top, 20)
                .disabled(!isFormValid)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 80)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Sign Up"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                      if alertMessage == "Account created successfully." {
                          presentationMode.wrappedValue.dismiss()
                      }
                  })
        }
    }
    
    private var isFormValid: Bool {
        return !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !password.isEmpty &&
               password == confirmPassword &&
               password.count >= 6 &&
               isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Simple regex for email validation
        let emailRegEx = #"^\S+@\S+\.\S+$"#
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }
    
    private func signUp() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedConfirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty, !trimmedConfirmPassword.isEmpty else {
            alertMessage = "All fields are required."
            showingAlert = true
            return
        }
        
        guard trimmedPassword == trimmedConfirmPassword else {
            alertMessage = "Passwords do not match."
            showingAlert = true
            return
        }
        
        guard trimmedPassword.count >= 6 else {
            alertMessage = "Password must be at least 6 characters long."
            showingAlert = true
            return
        }
        
        guard isValidEmail(trimmedEmail) else {
            alertMessage = "Please enter a valid email address."
            showingAlert = true
            return
        }
        
        do {
            _ = try await authManager.signUp(email: trimmedEmail, password: trimmedPassword)
            alertMessage = "Account created successfully."
            showingAlert = true
        } catch let error as NSError {
            // Handle Firebase errors
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthManager())
}
