//
//  ExerciseListView.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 18.11.2024.
//

import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var router: AddWorkoutRouter
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    let muscleGroup: String
    
    var exercises: [SpecificExerciseModel] {
        ExerciseList.allCases
            .filter { $0.details().groupOfMuscles == muscleGroup }
            .map { $0.details() }
    }
    
    var body: some View {
        VStack {
            ForEach(exercises, id: \.name) { exercise in
                Button {
                    viewModel.addExercise(exercise)
                    viewModel.dismissSheet()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundStyle(systemDarkBlueColor)
                        HStack {
                            Text(exercise.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    ExerciseListView(muscleGroup: "Legs")
}
