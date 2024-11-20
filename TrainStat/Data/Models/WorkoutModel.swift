//
//  WorkoutModel.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//

import Foundation

struct WorkoutModel {
    var id: UUID
    var exersises: [ExerciseModel]
    var intensivity: Int64
    var date: Date
    var time: String
    
    init() {
        id = UUID()
        exersises = []
        intensivity = 0
        date = Date()
        time = "00:00"
    }
}
