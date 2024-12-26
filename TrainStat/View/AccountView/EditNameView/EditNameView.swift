//
//  EditNameView.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/24/24.
//

import SwiftUI

struct EditNameView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newName: String = ""
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isUpdating: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("New Display Name")) {
                        TextField("Enter your new name", text: $newName)
                            .autocapitalization(.words)
                            .disableAutocorrection(true)
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                await updateName()
                            }
                        }) {
                            HStack {
                                Spacer()
                                if isUpdating {
                                    ProgressView()
                                } else {
                                    Text("Save")
                                        .fontWeight(.bold)
                                }
                                Spacer()
                            }
                        }
                        .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty || isUpdating)
                    }
                }
            }
            .navigationTitle("Edit Name")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Update Name"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")) {
                          if alertMessage == "Name updated successfully." {
                              presentationMode.wrappedValue.dismiss()
                          }
                      })
            }
        }
    }
    
    private func updateName() async {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            alertMessage = "Name cannot be empty."
            showingAlert = true
            return
        }
        
        isUpdating = true
        do {
            try await authManager.updateDisplayName(to: trimmedName)
            alertMessage = "Name updated successfully."
            showingAlert = true
        } catch {
            alertMessage = error.localizedDescription
            showingAlert = true
        }
        isUpdating = false
    }
}
