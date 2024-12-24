//
//  AchievmentsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 11.12.2024.
//

import SwiftUI


struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let isCompleted: Bool
    let date: Date?
}

let achievements: [Achievement] = [
    Achievement(title: "Your first workout", isCompleted: true, date: Date()),
    Achievement(title: "Do 5 workouts", isCompleted: false, date: nil),
    Achievement(title: "Do 10 workouts", isCompleted: false, date: nil),
    Achievement(title: "Workout 3 times a week", isCompleted: true, date: Date()),
]

struct AchievementsView: View {
    var body: some View {
            VStack {
                ScrollView {
                    StandartHeaderText(headerText: "Achivements")
                        .padding(.horizontal, 24)
                ForEach(achievements) { achievement in
                    AchievementRow(title: achievement.title, isAchieved: achievement.isCompleted, date: achievement.date)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 15)
                }
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
        }
        
    }
}


struct AchievementRow: View {
    let title: String
    let isAchieved: Bool
    let date: Date?
    
    var body: some View {
        HStack {
            Image(systemName: isAchieved ? "medal.fill" : "medal")
                .resizable()
                .frame(width: 50, height: 60)
                .foregroundColor(isAchieved ? yellowColor : gray3)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                if let date = date {
                    Text("Done: \(dateFormatter.string(from: date))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                } else {
                    Text("To be done")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.leading, 10)
            Spacer()
        }
        .padding()
        .background(isAchieved ? gray2 : gray5)
        .cornerRadius(15)
    }
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

#Preview {
    AchievementsView()
}
