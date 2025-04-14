//
//  SectionHeader.swift
//  TrainStat
//
//  Created by Alexander Goldebaev on 12/24/24.
//

import SwiftUICore

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.yellow)
            .padding(.horizontal)
            .padding(.top, 10)
    }
}
