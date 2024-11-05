//
//  Extension.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 05.11.2024.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
