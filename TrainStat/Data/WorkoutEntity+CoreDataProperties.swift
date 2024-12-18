//
//  WorkoutEntity+CoreDataProperties.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 20.11.2024.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var intensivity: Int64
    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var time: String?
    @NSManaged public var exercises: NSOrderedSet?

}

// MARK: Generated accessors for exercises
extension WorkoutEntity {

    @objc(insertObject:inExercisesAtIndex:)
    @NSManaged public func insertIntoExercises(_ value: ExerciseEntity, at idx: Int)

    @objc(removeObjectFromExercisesAtIndex:)
    @NSManaged public func removeFromExercises(at idx: Int)

    @objc(insertExercises:atIndexes:)
    @NSManaged public func insertIntoExercises(_ values: [ExerciseEntity], at indexes: NSIndexSet)

    @objc(removeExercisesAtIndexes:)
    @NSManaged public func removeFromExercises(at indexes: NSIndexSet)

    @objc(replaceObjectInExercisesAtIndex:withObject:)
    @NSManaged public func replaceExercises(at idx: Int, with value: ExerciseEntity)

    @objc(replaceExercisesAtIndexes:withExercises:)
    @NSManaged public func replaceExercises(at indexes: NSIndexSet, with values: [ExerciseEntity])

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSOrderedSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSOrderedSet)

}

extension WorkoutEntity : Identifiable {

}
