//
//  CoreDataManager.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        print("Successfully loaded container")
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Save
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    
    // MARK: - Fetch Functions
    func fetchWorkouts() -> [WorkoutEntity] {
        let fetchRequest: NSFetchRequest<WorkoutEntity> = WorkoutEntity.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch workouts: \(error)")
            return []
        }
    }
    
    func fetchExercises() -> [ExerciseEntity] {
        let fetchRequest: NSFetchRequest<ExerciseEntity> = ExerciseEntity.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch exercises: \(error)")
            return []
        }
    }
    
    func fetchSets() -> [SetEntity] {
        let fetchRequest: NSFetchRequest<SetEntity> = SetEntity.fetchRequest()
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch sets: \(error)")
            return []
        }
    }
    
    // MARK: - Delete Functions
    func deleteWorkout(_ workout: WorkoutEntity) {
        viewContext.delete(workout)
        do {
            try save()
        } catch {
            print("Failed to delete workout: \(error)")
        }
    }
    
    func deleteExercise(_ exercise: ExerciseEntity) {
        viewContext.delete(exercise)
        do {
            try save()
        } catch {
            print("Failed to delete exercise: \(error)")
        }
    }
    
    func deleteSet(_ set: SetEntity) {
        viewContext.delete(set)
        do {
            try save()
        } catch {
            print("Failed to delete set: \(error)")
        }
    }
    
    // MARK: - Universal Create Function
    func createWorkoutWithExercisesAndSets(workoutModel: WorkoutModel) {
        let workout = WorkoutEntity(context: viewContext)
        workout.id = workoutModel.id
        workout.date = workoutModel.date
        workout.intensivity = workoutModel.intensivity
        workout.time = workoutModel.time
        
        var exerciseEntities: [ExerciseEntity] = []
        
        for exerciseData in workoutModel.exersises {
            let exercise = ExerciseEntity(context: viewContext)
            exercise.id = exerciseData.id
            exercise.name = exerciseData.exercise.name
            exercise.intensivity = exerciseData.exercise.intensivity
            exercise.image = exerciseData.exercise.image
            exercise.groupOfMuscles = exerciseData.exercise.groupOfMuscles
            exercise.workout = workout
            
            var setEntities: [SetEntity] = []
            
            for setData in exerciseData.sets {
                let set = SetEntity(context: viewContext)
                set.index = setData.index
                set.weight = setData.weight
                set.repeats = setData.repeats
                set.isDone = setData.isDone
                set.exercise = exercise
                setEntities.append(set)
            }
            
            exercise.addToSets(NSOrderedSet(array: setEntities))
            exerciseEntities.append(exercise)
        }
        
        workout.addToExercises(NSOrderedSet(array: exerciseEntities))

        do {
            try save()
            print("Successfully created workout with exercises and sets!")
        } catch {
            print("Failed to create workout: \(error)")
        }
    }
}
