//
//  OneExerciseStatisticsViewModel.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 18.12.2024.
//

import SwiftUI

actor OneExerciseDataProcessor {
    private var tempData: [Double] = []

    func processWorkouts(workouts: FetchedResults<WorkoutEntity>, exercise: SpecificExerciseModel) async -> [Double] {
        var localData: [Double] = []
        
        for workout in workouts.reversed() {
            guard let exercises = workout.exercises else { continue }
            for case let exerciseEntity as ExerciseEntity in exercises {
                if exerciseEntity.name == exercise.name {
                    if let sets = exerciseEntity.sets {
                        let maxWeight = sets.compactMap { ($0 as? SetEntity)?.weight }.max() ?? 0.0
                        localData.append(maxWeight)
                        if localData.count == 7 {
                            return localData
                        }
                    }
                }
            }
            if localData.count == 7 {
                break
            }
        }
        
        return localData
    }
}

class OneExerciseStatisticsViewModel: ObservableObject {
    @Published var maxWeightOfExerciseData: [Double] = []
    private let dataProcessor = OneExerciseDataProcessor()
    
    func setupWeightChart(workouts: FetchedResults<WorkoutEntity>, exercise: SpecificExerciseModel) async {
        let processedData = await dataProcessor.processWorkouts(workouts: workouts, exercise: exercise)
        
        await MainActor.run {
            maxWeightOfExerciseData = processedData.reversed()
        }
    }
}
