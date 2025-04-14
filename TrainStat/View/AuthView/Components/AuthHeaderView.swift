//
//  AuthHeaderView.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/20/24.
//

import SwiftUI

struct AuthHeaderView: View {
    let title: String
    let onSkip: (() -> Void)?

    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.yellow)

            Spacer()

            Button(action: {
                onSkip?()
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
            }
        }
    }
}
