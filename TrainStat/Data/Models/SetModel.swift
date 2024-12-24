//
//  SetModel.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//

struct SetModel {
    var index: Int16
    var weight: Double
    var repeats: Int16
    var isDone: Bool
    
    init(index: Int16) {
        self.index = index
        self.weight = 0
        self.repeats = 0
        self.isDone = false
    }
    
    init(index: Int16, weight: Double, repeats: Int16) {
        self.index = index
        self.weight = weight
        self.repeats = repeats
        self.isDone = false
    }
}
