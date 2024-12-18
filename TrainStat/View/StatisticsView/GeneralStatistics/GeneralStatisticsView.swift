//
//  GeneralStatisticsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 11.12.2024.
//

import SwiftUI
import SwiftUICharts

struct GeneralStatisticsView: View {
    @FetchRequest(
        entity: WorkoutEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutEntity.date, ascending: true)]) var workouts: FetchedResults<WorkoutEntity>
    
    @StateObject private var stat = GeneralStatisticsViewModel()
    
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
    
    init() {
        chartStyle.darkModeStyle = darkChartStyle
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            VStack(spacing: 32) {
                StandartHeaderText(headerText: "General statistics")
                    .padding(.leading, 21)
                ScrollView {
                    LazyVStack(spacing: 16) {
                        BarChartView(data: ChartData(values: stat.timeChartData), title: "Training time (in minutes)", legend: "Tatata", style: chartStyle, form: ChartForm.extraLarge, dropShadow: false, valueSpecifier: "%.0f minute(s)")
                            .padding(.top, 8)
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Total weight")
                                .padding(.leading)
                                .font(.headline)
                            LineView(data: stat.totalWeightChartData, style: chartStyle, valueSpecifier: "%.0f kg")
                        }
                            
                    }
                    .padding(.horizontal, 40)
                }
                Spacer()
            }
            
        }
        .onAppear {
            stat.setupTimeChart(workouts: workouts)
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
    GeneralStatisticsView()
}
