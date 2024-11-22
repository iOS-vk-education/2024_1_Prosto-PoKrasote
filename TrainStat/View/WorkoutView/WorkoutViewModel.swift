//
//  WorkoutViewModel.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 15.11.2024.
//

import SwiftUI

class WorkoutViewModel: ObservableObject {
    @Published var workoutModel: WorkoutModel = WorkoutModel()
    private let coreDataManager = CoreDataManager.shared
    
    @Published var timeString: String = "00:00"
    @Published var isSheetShowing: Bool = false
    @Published var workoutResultScreen: Bool = true
    
    private var timer: Timer?
    private var totalSeconds: Int = 0
    
    func startWorkout() {
        showSheet()
        startTimer()
    }
    
    func plusButtonTapped() {
        if timeString == "00:00" {
            startTimer()
        }
        showSheet()
    }
    
    // MARK: FIX
    // workoutIntensivity fix -> set it
    // right now const 0
    func workoutIntensivityResult() -> Int64 {
        var result = 0.0
        workoutModel.exersises.forEach {exercise in
            exercise.sets.forEach {set in
                result += set.weight * Double(set.repeats)
            }
        }
        return Int64(result)
    }
    func endWorkoutButtonTapped() {
        workoutModel.time = "\(timeString)"
        stopTimer()
        workoutModel.date = Date()
        workoutModel.intensivity = workoutIntensivityResult()
        saveWorkoutInCoreData()
        workoutResultScreen = true
    }
    
    func closeWorkoutResultScreen() {
        workoutResultScreen = false
        workoutModel = WorkoutModel()
    }
    
    func showSheet() {
        isSheetShowing = true
    }
    
    func dismissSheet() {
        isSheetShowing = false
    }
    
    // MARK: FIX
    // check if set.count == 0 || set.isDone = false -> delete set or exercise
    private func saveWorkoutInCoreData() {
        coreDataManager.createWorkoutWithExercisesAndSets(workoutModel: workoutModel)
    }
    
    func addExercise(_ exercise: SpecificExerciseModel) {
        workoutModel.exersises.append(ExerciseModel(exercise: exercise))
        print(workoutModel.exersises)
    }
    
    func addSet(_ exercise: ExerciseModel) {
        if let index = workoutModel.exersises.firstIndex(where: {$0.id == exercise.id}) {
            workoutModel.exersises[index].sets.append(SetModel(index: Int16(workoutModel.exersises[index].sets.count)))
        }
    }
    
    func saveSet(_ exercise: ExerciseModel, _ set: SetModel, weight: Double?, reps: Int?) {
        if let index = workoutModel.exersises.firstIndex(where: {$0.id == exercise.id}) {
            if let weight {
                workoutModel.exersises[index].sets[Int(set.index)].weight = weight
            }
            if let reps {
                workoutModel.exersises[index].sets[Int(set.index)].repeats = Int16(reps)
            }
        }
    }
    
    func doneSet(_ exercise: ExerciseModel, _ set: SetModel) {
        if let index = workoutModel.exersises.firstIndex(where: {$0.id == exercise.id}) {
            workoutModel.exersises[index].sets[Int(set.index)].isDone = true
        }
    }
    
    private func startTimer() {
        stopTimer()
        totalSeconds = 0
        timeString = formatTimeForTimer(totalSeconds)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tickTimer()
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        totalSeconds = 0
        timeString = formatTimeForTimer(totalSeconds)
    }
    
    private func tickTimer() {
        totalSeconds += 1
        timeString = formatTimeForTimer(totalSeconds)
    }
    
    private func formatTimeForTimer(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
