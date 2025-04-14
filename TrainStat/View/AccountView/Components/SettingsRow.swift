//
//  SectionRow.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/24/24.
//

import SwiftUICore

struct SettingsRow: View {
    let icon: String
    let title: String
    var info: String? = nil

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.yellow)
                .frame(width: 24, height: 24)
            Text(title)
                .foregroundColor(.white)
            Spacer()
            if let info = info {
                Text(info)
                    .foregroundColor(.gray)
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
