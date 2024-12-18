//
//  SpecificExerciseModel.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//

struct SpecificExerciseModel: Hashable, Equatable {
    var name: String
    var image: String
    var groupOfMuscles: String
    var intensivity: Int64
    
    init(name: String, image: String, groupOfMuscles: String, intensivity: Int64) {
        self.name = name
        self.image = image
        self.groupOfMuscles = groupOfMuscles
        self.intensivity = intensivity
    }
}
