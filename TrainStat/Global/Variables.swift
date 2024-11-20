//
//  Variables.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 11.11.2024.
//

import SwiftUI

enum MuscleGroup: String, CaseIterable {
    case chest = "Chest"
    case legs = "Legs"
    case back = "Back"
    case arm = "Arm"
    case shoulder = "Shoulder"
    case abs = "Abs"
}

enum ExerciseList: CaseIterable {
    case barbellBenchPress
    case inclineDumbbellPress
    case pecDeckFly
    case barbellSquats
    case legPress
    case dumbbellLunges
    case bentOverBarbellRow
    case latPulldown
    case weightedPullUps
    case barbellBicepCurls
    case frenchPress
    case hammerCurls
    case overheadBarbellPress
    case lateralRaises
    case frontBarbellRaises
    case weightedCrunches
    case hangingLegRaises
    case russianTwists

    func details() -> SpecificExerciseModel {
        switch self {
        case .barbellBenchPress:
            return SpecificExerciseModel(name: "Barbell bench press", image: "barbell_bench_press_image", groupOfMuscles: MuscleGroup.chest.rawValue, intensivity: 0)
        case .inclineDumbbellPress:
            return SpecificExerciseModel(name: "Incline dumbbell press", image: "incline_dumbbell_press_image", groupOfMuscles: MuscleGroup.chest.rawValue, intensivity: 1)
        case .pecDeckFly:
            return SpecificExerciseModel(name: "Pec deck fly", image: "pec_deck_fly_image", groupOfMuscles: MuscleGroup.chest.rawValue, intensivity: 2)
        case .barbellSquats:
            return SpecificExerciseModel(name: "Barbell squats", image: "barbell_squats_image", groupOfMuscles: MuscleGroup.legs.rawValue, intensivity: 2)
        case .legPress:
            return SpecificExerciseModel(name: "Leg press", image: "leg_press_image", groupOfMuscles: MuscleGroup.legs.rawValue, intensivity: 1)
        case .dumbbellLunges:
            return SpecificExerciseModel(name: "Dumbbell lunges", image: "dumbbell_lunges_image", groupOfMuscles: MuscleGroup.legs.rawValue, intensivity: 2)
        case .bentOverBarbellRow:
            return SpecificExerciseModel(name: "Bent-over barbell row", image: "bent_over_barbell_row_image", groupOfMuscles: MuscleGroup.back.rawValue, intensivity: 2)
        case .latPulldown:
            return SpecificExerciseModel(name: "Lat pulldown", image: "lat_pulldown_image", groupOfMuscles: MuscleGroup.back.rawValue, intensivity: 1)
        case .weightedPullUps:
            return SpecificExerciseModel(name: "Weighted pull-ups", image: "weighted_pull_ups_image", groupOfMuscles: MuscleGroup.back.rawValue, intensivity: 3)
        case .barbellBicepCurls:
            return SpecificExerciseModel(name: "Barbell bicep curls", image: "barbell_bicep_curls_image", groupOfMuscles: MuscleGroup.arm.rawValue, intensivity: 1)
        case .frenchPress:
            return SpecificExerciseModel(name: "French press", image: "french_press_image", groupOfMuscles: MuscleGroup.arm.rawValue, intensivity: 2)
        case .hammerCurls:
            return SpecificExerciseModel(name: "Hammer curls", image: "hammer_curls_image", groupOfMuscles: MuscleGroup.arm.rawValue, intensivity: 1)
        case .overheadBarbellPress:
            return SpecificExerciseModel(name: "Overhead barbell press", image: "overhead_barbell_press_image", groupOfMuscles: MuscleGroup.shoulder.rawValue, intensivity: 2)
        case .lateralRaises:
            return SpecificExerciseModel(name: "Lateral raises", image: "lateral_raises_image", groupOfMuscles: MuscleGroup.shoulder.rawValue, intensivity: 1)
        case .frontBarbellRaises:
            return SpecificExerciseModel(name: "Front barbell raises", image: "front_barbell_raises_image", groupOfMuscles: MuscleGroup.shoulder.rawValue, intensivity: 1)
        case .weightedCrunches:
            return SpecificExerciseModel(name: "Weighted crunches", image: "weighted_crunches_image", groupOfMuscles: MuscleGroup.abs.rawValue, intensivity: 2)
        case .hangingLegRaises:
            return SpecificExerciseModel(name: "Hanging leg raises", image: "hanging_leg_raises_image", groupOfMuscles: MuscleGroup.abs.rawValue, intensivity: 3)
        case .russianTwists:
            return SpecificExerciseModel(name: "Russian twists", image: "russian_twists_image", groupOfMuscles: MuscleGroup.abs.rawValue, intensivity: 2)
        }
    }
}

var systemDarkBlueColor: Color = Color(uiColor: UIColor(hex: "192126"))
var yellowColor: Color = Color(uiColor: UIColor(hex: "FED709"))
var gray1: Color = Color(uiColor: UIColor(hex: "474747"))
var gray2: Color = Color(uiColor: UIColor(hex: "2E2E2E"))
var gray3: Color = Color(uiColor: UIColor(hex: "525252"))
var gray4: Color = Color(uiColor: UIColor(hex: "383838"))
var gray5: Color = Color(uiColor: UIColor(hex: "1A1A1A"))
var gray6: Color = Color(uiColor: UIColor(hex: "212121"))
