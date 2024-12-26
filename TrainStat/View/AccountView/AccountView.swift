//
//  AccountView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @State private var isDarkModeOn = true
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    profileSection
                    settingsSections
                    darkModeToggle
                    authButtons
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 50)
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.ignoresSafeArea())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")))
        }
    }

    @ViewBuilder
    private var profileSection: some View {
        switch authManager.authState {
        case .authenticated, .signedIn:
            HStack {
                profileImage
                userInfo
                Spacer()
                if (authManager.authState == .signedIn)
                {
                    Button(action: {
                        editProfile()
                    }) {
                        Image(systemName: "pencil.circle")
                            .font(.title)
                            .foregroundColor(.yellow)
                    }
                }
            }
            .padding()
        case .signedOut:
            VStack(alignment: .leading, spacing: 10) {
                Text("Welcome to TrainStat!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Text("Please sign in or create an account to continue.")
                    .foregroundColor(.white)
            }
            .padding()
        }
    }

    private var profileImage: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 60, height: 60)
            .foregroundColor(.gray)
    }

    @ViewBuilder
    private var userInfo: some View {
        if let user = authManager.user {
            VStack(alignment: .leading) {
                Text(displayName(from: user))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Text(userEmail(from: user))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        } else {
            VStack(alignment: .leading) {
                Text("Anonymous User")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Text("No additional info")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    @ViewBuilder
    private var settingsSections: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionHeader(title: "Security")
            VStack(spacing: 20) {
                NavigationLink(destination: Text("OK")) {
                    SettingsRow(icon: "lock", title: "Change Password")
                }
                NavigationLink(destination: Text("What?")) {
                    SettingsRow(icon: "lock.open", title: "Forgot Password")
                }
                NavigationLink(destination: Text("Super secure security")) {
                    SettingsRow(icon: "shield", title: "Security")
                }
            }
            .padding(.horizontal)

            SectionHeader(title: "General")
            VStack(spacing: 20) {
                NavigationLink(destination: Text("A片")) {
                    SettingsRow(icon: "globe", title: "Language")
                }
                NavigationLink(destination: Text("Cache has been cleared (no)")) {
                    SettingsRow(icon: "trash", title: "Clear Cache", info: "88 MB")
                }
            }
            .padding(.horizontal)

            SectionHeader(title: "About")
            VStack(spacing: 20) {
                NavigationLink(destination: Text("Privacy Policies")) {
                    SettingsRow(icon: "shield.lefthalf.fill", title: "Legal and Policies")
                }
                NavigationLink(destination: Text("Help yourself")) {
                    SettingsRow(icon: "questionmark.circle", title: "Help & Support")
                }
            }
            .padding(.horizontal)
        }
    }

    private var darkModeToggle: some View {
        Toggle(isOn: $isDarkModeOn) {
            HStack {
                Image(systemName: isDarkModeOn ? "moon.stars.fill" : "sun.max.fill")
                    .foregroundColor(.yellow)
                Text("Dark Mode")
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }

    @ViewBuilder
    private var authButtons: some View {
        switch authManager.authState {
        case .authenticated, .signedIn:
            Button(action: {
                signOut()
            }) {
                Text("Log out")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 2)
                    )
            }
            .padding(.horizontal)
        case .signedOut:
            VStack(spacing: 10) {
                NavigationLink(destination: LoginView()) {
                    Text("Log in")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.yellow, lineWidth: 2)
                        )
                }

                NavigationLink(destination: SignUpView()) {
                    Text("Sign up")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal)
        }
    }

    private func displayName(from user: User) -> String {
        if let name = user.displayName, !name.isEmpty {
            return name
        } else {
            return user.isAnonymous ? "Anonymous User" : "User"
        }
    }

    private func userEmail(from user: User) -> String {
        if let email = user.email {
            return email
        } else {
            return "No Email"
        }
    }

    private func signOut() {
        Task {
            do {
                try await authManager.signOut()
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
                print("Error signing out: \(error)")
            }
        }
    }
    
    private func editProfile() {
        
    }
}

#Preview {
    AccountView()
        .environmentObject(AuthManager())
}
