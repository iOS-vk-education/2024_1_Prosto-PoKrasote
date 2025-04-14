//
//  AuthTextField.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/20/24.
//

import SwiftUI

struct AuthTextField: View {
    let title: String
    let placeholder: String
    let isSecure: Bool
    
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundColor(.yellow)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
            } else {
                TextField(placeholder, text: $text)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
            }
        }
    }
}
