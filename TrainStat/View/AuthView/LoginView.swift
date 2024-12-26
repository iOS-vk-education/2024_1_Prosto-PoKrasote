//
//  LoginView.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/20/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var onSkip: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                AuthHeaderView(title: "Welcome!", onSkip: onSkip)
                
                Text("Please, login or sign up")
                    .foregroundColor(.white)
                
                AuthTextField(title: "Email", placeholder: "Enter your email address", isSecure: false, text: $email)
                AuthTextField(title: "Password", placeholder: "Enter your password", isSecure: true, text: $password)
                
                Button(action: {
                    Task {
                        await login()
                    }
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .cornerRadius(5)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 80)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login Failed"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func login() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            alertMessage = "Please enter both email and password."
            showingAlert = true
            return
        }
        
        do {
            _ = try await authManager.signIn(email: trimmedEmail, password: trimmedPassword)
            // Optionally, dismiss the login view if needed
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
