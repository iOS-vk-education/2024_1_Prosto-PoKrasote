//
//  SetEntity+CoreDataProperties.swift
//  
//
//  Created by Kovalev Gleb on 20.11.2024.
//
//

import Foundation
import CoreData


extension SetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetEntity> {
        return NSFetchRequest<SetEntity>(entityName: "SetEntity")
    }

    @NSManaged public var weight: Double
    @NSManaged public var repeats: Int16
    @NSManaged public var isDone: Bool
    @NSManaged public var index: Int16
    @NSManaged public var exercise: ExerciseEntity?

}
