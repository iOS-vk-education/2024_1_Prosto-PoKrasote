//
//  AuthView.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/20/24.
//

import SwiftUI

public struct AuthView: View {
    @State private var tabSelection: Int = 1
    
    @EnvironmentObject var authManager: AuthManager
    
    public var body: some View {
        VStack {
            TabView(selection: $tabSelection) {
                LoginView(
                    onSkip: signAnonymously
                )
                .tag(1)
                
                SignUpView(
                    onSkip: signAnonymously
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: tabSelection)
            
            Spacer()
            
            if tabSelection == 1 {
                HStack {
                    Text("Don’t have an account?")
                        .foregroundColor(.white)
                    Button(action: {
                        withAnimation {
                            tabSelection = 2
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.yellow)
                            .bold()
                    }
                }
                .padding()
        } else if tabSelection == 2 {
                HStack {
                    Text("Already have an account?")    
                        .foregroundColor(.white)
                    Button(action: {
                        withAnimation {
                            tabSelection = 1
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.yellow)
                            .bold()
                    }
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    func signAnonymously() {
        Task {
            do {
                _ = try await authManager.signInAnonymously()
            }
            catch {
                print("SignInAnonymouslyError: \(error)")
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}
