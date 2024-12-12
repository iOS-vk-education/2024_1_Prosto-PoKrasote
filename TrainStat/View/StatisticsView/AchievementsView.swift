//
//  AchievmentsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 11.12.2024.
//

import SwiftUI

// todo bueeeeee
let userAchievements: [(title: String, isAchieved: Bool)] = [
    ("your first workout", true),
    ("do 5 workouts", false),
    ("do 10 workouts", true),
    ("3 times a week", false)
]

struct AchievementsView: View {
    var body: some View {
        VStack {
            StandartHeaderText(headerText: "Achivements")
                .padding(.horizontal, 24)
            /*
            ForEach(0..<userAchievements.count / 3 + (userAchievements.count % 3 == 0 ? 0 : 1), id: \.self) { index in
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { innerIndex in
                        let itemIndex = index * 3 + innerIndex
                        if itemIndex < userAchievements.count {
                            AchievementView(title: userAchievements[itemIndex].title,
                                            isAchieved: userAchievements[itemIndex].isAchieved)
                            //.frame(maxWidth: .infinity) // Занять всю доступную ширину
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            } */
                
            
            HStack(spacing: 20) {
                AchievementView(achievementTitle: "your first workout", isAchieved: true)
                AchievementView(achievementTitle: "do 5 workouts", isAchieved: true)
                AchievementView(achievementTitle: "do 10 workouts", isAchieved: false)
            }
            .padding()
            .frame(maxWidth: .infinity)
            HStack(spacing: 20) {
                AchievementView(achievementTitle: "3 times a week", isAchieved: false)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
    }
}


struct AchievementView: View {
    private var achievementTitle: String
    private var isAchieved: Bool
    
    private let squareSize: CGFloat = 110.0
    private let spacing: CGFloat = 20.0
    
    init(achievementTitle: String, isAchieved: Bool) {
        self.achievementTitle = achievementTitle
        self.isAchieved = isAchieved
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            Image(systemName: isAchieved ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: squareSize, height: squareSize)
                .foregroundColor(isAchieved ? yellowColor : .gray)
            Text(achievementTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    AchievementsView()
}
