//
//  StandartHeaderText.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//

import SwiftUI

struct StandartHeaderText: View {
    
    @State var headerText: String
    
    var body: some View {
        HStack {
            Text(headerText)
                .font(.system(size: 32))
                .fontWeight(.bold)
                .foregroundStyle(yellowColor)
            Spacer()
        }
    }
}

#Preview {
    StandartHeaderText(headerText: "Good job!")
}
