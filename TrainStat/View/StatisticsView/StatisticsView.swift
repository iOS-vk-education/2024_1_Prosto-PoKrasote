//
//  StatisticsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var router: StatisticsRouter
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 48) {
                StandartHeaderText(headerText: "Statistics")
                    .padding(.horizontal, 24)
                StatisticsBigButton(header: "Achivments") {
                    router.navigateTo(.achievementView)
                }
                StatisticsBigButton(header: "General statistics") {
                    router.navigateTo(.generalStatisticsView)
                }
                StatisticsBigButton(header: "Exercise statistics") {
                    router.navigateTo(.exerciseStatisticsView)
                }
                
                Spacer()
            }
        }
    }
    
}

struct StatisticsBigButton: View {
    @State var header: String
    
    let action: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(systemDarkBlueColor)
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .trim(from: 0.25, to: 0.5)
                        .stroke(yellowColor, lineWidth: 10)
                        .frame(width: 125, height: 125)
                        .blur(radius: 4)
                        .offset(x: 62.5, y: -62.5)
                }
                Spacer()
            }
            HStack(spacing: 16) {
                Text(header)
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                Image(systemName: "circle.fill")
                    .font(.system(size: 50))
                Spacer()
            }
            .foregroundStyle(yellowColor)
                
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .frame(height: 160)
        .padding(.horizontal, 32)
        .onTapGesture {
            action()
        }
    }
}



#Preview {
    StatisticsView()
}
