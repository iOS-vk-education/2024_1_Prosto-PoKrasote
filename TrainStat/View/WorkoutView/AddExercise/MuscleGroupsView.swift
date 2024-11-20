//
//  WorkoutAddExerciseView.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 18.11.2024.
//

import SwiftUI

struct MuscleGroupsView: View {
    @EnvironmentObject var router: AddWorkoutRouter
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    var body: some View {
        VStack {
            StandartHeaderText(headerText: "Choose exercise")
                .padding(.leading, 21)
            ForEach(MuscleGroup.allCases, id: \.self) { group in
                Button(action: {
                    router.navigateTo(.exerciseList(group.rawValue))
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundStyle(systemDarkBlueColor)
                        HStack {
                            Text(group.rawValue)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                        .padding(.trailing, 16)
                    }
                }
            }
            .padding(.horizontal, 32)
            Spacer()
        }
    }
}

#Preview {
    MuscleGroupsView()
}
