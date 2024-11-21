//
//  Exersice.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 15.11.2024.
//

import Foundation

struct ExerciseModel: Identifiable {
    var id: UUID
    var exercise: SpecificExerciseModel
    var sets: [SetModel]
    
    init(exercise: SpecificExerciseModel) {
        self.id = UUID()
        self.exercise = exercise
        self.sets = []
    }
}
