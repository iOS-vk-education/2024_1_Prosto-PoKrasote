//
//  OneExerciseStatisticsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 18.12.2024.
//

import SwiftUI
import SwiftUICharts

struct OneExerciseStatisticsView: View {
    @FetchRequest(
        entity: WorkoutEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]) var workouts: FetchedResults<WorkoutEntity>
    
    var exercise: SpecificExerciseModel
    
    @StateObject private var viewModel = OneExerciseStatisticsViewModel()
    
    @EnvironmentObject private var router: StatisticsRouter
    
    let chartStyle = ChartStyle(
        backgroundColor: .black,
        accentColor: yellowColor,
        secondGradientColor: .orange,
        textColor: .white,
        legendTextColor: .black,
        dropShadowColor: .black
    )
    
    let darkChartStyle = ChartStyle(
        backgroundColor: .black,
        accentColor: yellowColor,
        secondGradientColor: .orange,
        textColor: .white,
        legendTextColor: .black,
        dropShadowColor: .black
    )
    
    init(exercise: SpecificExerciseModel) {
        self.exercise = exercise
        chartStyle.darkModeStyle = darkChartStyle
    }
    
    var body: some View {
        VStack(spacing: 32) {
            StandartHeaderText(headerText: exercise.name)
                .padding(.leading, 21)
            ScrollView {
                LazyVStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Max weight of workout")
                            .padding(.leading)
                            .font(.headline)
                        LineView(data: viewModel.maxWeightOfExerciseData, style: chartStyle, valueSpecifier: "%.0f kg")
                    }
                        
                }
                .padding(.horizontal, 40)
            }
            Spacer()
        }
        .task {
            await viewModel.setupWeightChart(workouts: workouts, exercise: exercise)
        }
        .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        router.navigateBack()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(yellowColor)
                    }
                }
            }
    }
}

#Preview {
    OneExerciseStatisticsView(exercise: SpecificExerciseModel(name: "Barpbell curl", image: "", groupOfMuscles: "Ruki", intensivity: 3))
}
