//
//  AccountView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI

struct AccountView: View {
    @State private var isDarkModeOn = true
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .background(.gray)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text("Jhon Doe") // var
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.yellow)
                            Text("@HateSwift123") // var
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Button(action: {
                            // edit handler
                        }) {
                            Image(systemName: "pencil.circle")
                                .font(.title)
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    
                    SectionHeader(title: "Security")
                    VStack(spacing: 20) {
                        NavigationLink(destination: Text("Change Password")) {
                            SettingsRow(icon: "lock", title: "Change Password")
                        }
                        NavigationLink(destination: Text("Forgot Password")) {
                            SettingsRow(icon: "lock", title: "Forgot Password")
                        }
                        NavigationLink(destination: Text("Security")) {
                            SettingsRow(icon: "shield", title: "Security")
                        }
                    }
                    .padding(.horizontal)
                    
                    SectionHeader(title: "General")
                    VStack(spacing: 20) {
                        NavigationLink(destination: Text("Language")) {
                            SettingsRow(icon: "globe", title: "Language")
                        }
                        NavigationLink(destination: Text("Clear Cache")) {
                            HStack {
                                SettingsRow(icon: "trash", title: "Clear Cache", info: "88 MB")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    SectionHeader(title: "About")
                    VStack(spacing: 20) {
                        NavigationLink(destination: Text("Legal and Policies")) {
                            SettingsRow(icon: "shield", title: "Legal and Policies")
                        }
                        NavigationLink(destination: Text("Help & Support")) {
                            SettingsRow(icon: "questionmark.circle", title: "Help & Support")
                        }
                    }
                    .padding(.horizontal)
                    
                    Toggle(isOn: $isDarkModeOn) {
                        HStack {
                            Image(systemName: isDarkModeOn ? "moon.stars" : "sun.max")
                                .foregroundColor(.yellow)
                            Text("Dark Mode")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    
                    Button(action: {
                    }) {
                        Text("Log out")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                    }
                    .padding()
                }
            }
            .padding(.bottom, 50)
        }
        .background(Color.black.ignoresSafeArea())
    }
}

struct SectionHeader: View {
var title: String

var body: some View {
Text(title)
    .font(.headline)
    .foregroundStyle(.gray)
    .foregroundColor(.white)
    .padding(.top)
    .padding(.horizontal)
    .padding(.bottom, 8)
}
}


struct SettingsRow: View {
var icon: String
var title: String
var info: String?

var body: some View {
HStack {
    Image(systemName: icon)
        .foregroundColor(.yellow)
    Text(title)
        .fontWeight(.medium)
        .foregroundColor(.white)
    Spacer()
    if info != nil {
        Text(info!)
            .font(.subheadline)
            .foregroundColor(.gray)
    }
    Image(systemName: "chevron.right")
        .foregroundColor(.gray)
}
    }
}

#Preview {
    AccountView()
}
