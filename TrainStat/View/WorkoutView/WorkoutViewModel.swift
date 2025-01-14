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
    @Published var setTimeString: String = "00:00"
    
    @Published var isSheetShowing: Bool = false
    @Published var workoutResultScreen: Bool = false
    
    private var timer: Timer?
    private var startTime: Date?
    
    private var setTimer: Timer?
    private var setStartTime: Date?
    
    func plusButtonTapped() {
        showSheet()
    }
    
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
    
    func checkTimer() {
        if startTime == nil {
            startTimer()
        }
    }
    
    func addSet(_ exercise: ExerciseModel) {
        if let index = workoutModel.exersises.firstIndex(where: { $0.id == exercise.id }) {
            if workoutModel.exersises[index].sets.count != 0 {
                workoutModel.exersises[index].sets.append(SetModel(index: Int16(workoutModel.exersises[index].sets.count),
                                                                   weight: workoutModel.exersises[index].sets[workoutModel.exersises[index].sets.count - 1].weight,
                                                                   repeats: workoutModel.exersises[index].sets[workoutModel.exersises[index].sets.count - 1].repeats))
            } else {
                workoutModel.exersises[index].sets.append(SetModel(index: Int16(workoutModel.exersises[index].sets.count)))
            }
        }
    }
    
    func saveSet(_ exercise: ExerciseModel, _ setIndex: Int, weight: Double?, reps: Int?) {
        if let index = workoutModel.exersises.firstIndex(where: { $0.id == exercise.id }) {
            if let weight {
                workoutModel.exersises[index].sets[setIndex].weight = weight
            }
            if let reps {
                workoutModel.exersises[index].sets[setIndex].repeats = Int16(reps)
            }
        }
    }
    
    func doneSet(_ exercise: ExerciseModel, _ set: SetModel) {
        if let index = workoutModel.exersises.firstIndex(where: { $0.id == exercise.id }) {
            workoutModel.exersises[index].sets[Int(set.index)].isDone = true
        }
    }
    
    private func startTimer() {
        stopTimer()
        startTime = Date()
        updateTimerString() 
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimerString()
        }
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        startTime = nil
        timeString = "00:00"
    }
    
    private func updateTimerString() {
        guard let startTime = startTime else { return }
        let elapsedTime = Int(Date().timeIntervalSince(startTime))
        timeString = formatTimeForTimer(elapsedTime)
    }
    
    func startSetTimer() {
        stopSetTimer()
        setStartTime = Date()
        updateSetTimerString()
        setTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateSetTimerString()
        }
    }
    
    func stopSetTimer() {
        setTimer?.invalidate()
        setTimer = nil
        setStartTime = nil
        setTimeString = "00:00"
    }
    
    private func updateSetTimerString() {
        guard let setStartTime = setStartTime else { return }
        let elapsedTime = Int(Date().timeIntervalSince(setStartTime))
        setTimeString = formatTimeForTimer(elapsedTime)
    }
    
    private func formatTimeForTimer(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
