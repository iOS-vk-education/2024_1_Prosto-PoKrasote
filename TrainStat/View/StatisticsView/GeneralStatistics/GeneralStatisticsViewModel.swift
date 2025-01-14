//
//  GeneralStatisticsViewModel.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.12.2024.
//

import SwiftUI
import CoreData
import SwiftUICharts


class GeneralStatisticsViewModel: ObservableObject {
    @Published var timeChartData: [(String, Int)] = []
    @Published var totalWeightChartData: [Double] = []
    
    func setupTimeChart(workouts: FetchedResults<WorkoutEntity>) {
        print("Fetched workouts: \(workouts.count)")
        
        let lastWorkouts = workouts.suffix(7)
        
        timeChartData = lastWorkouts.compactMap { workout in
            if let workoutDate = workout.date, let workoutTime = workout.time {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM"
                let formattedDate = dateFormatter.string(from: workoutDate)
                
                let timeComponents = workoutTime.split(separator: ":").map { String($0) }
                var time = 0
                
                if timeComponents.count == 2,
                   let minutes = Int(timeComponents[0]),
                   let seconds = Int(timeComponents[1]) {
                    time = minutes + (seconds != 0 ? 1 : 0)
                } else {
                    time = 0
                }
                
                return (formattedDate, time)
            }
            
            return nil
        }
        
        totalWeightChartData = lastWorkouts.compactMap { workout in
            return Double(Int(truncatingIfNeeded: workout.intensivity))
        }
        
        print("Processed workouts: \(timeChartData.count)")
    }
}
