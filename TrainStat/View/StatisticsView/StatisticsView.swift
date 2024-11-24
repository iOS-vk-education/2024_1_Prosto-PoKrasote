//
//  StatisticsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 12.11.2024.
//

import SwiftUI

private enum Constant {
    static let title: String = "Statistics"
    static let cornerRadius: CGFloat = 20
    static let buttonFontSize: CGFloat = 20
    static let titlesize: CGFloat = 30
}


struct ExerciseView: View {
    let exercise: SpecificExerciseModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: Constant.cornerRadius)
                .foregroundColor(systemDarkBlueColor)
                .frame(height: 140)
                .padding(.horizontal, 16)
            
            HStack {
                /*
                Image(exercise.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .padding(.leading, 10)
                 */ // WARN add exercise icons
                Rectangle()
                    .fill(gray3)
                    .frame(width: 40, height: 40)
                    .offset(x: 32, y: 10)
                            
                Text(exercise.name)
                    .padding(.horizontal, 32)
                    .offset(y: 10)
                    .fontWeight(.bold)
                    .font(.system(size: Constant.buttonFontSize))
                    .foregroundColor(.white)
                
            }
            
            Rectangle()
                .fill(yellowColor)
                .frame(height: 60)
                .padding(.horizontal, 32)
                .offset(y: 70)
        }
    }
}

struct StatisticsView: View {
    var body: some View {
        ScrollView {
            Text(Constant.title)
                .fontWeight(.bold)
                .font(.system(size: Constant.titlesize))
                .foregroundColor(.white)
            VStack(spacing: 15) {
                // TODO .allCases -> .startedCases
                ForEach(ExerciseList.allCases, id: \.self) { exercise in
                    ExerciseView(exercise: exercise.details())
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
}


#Preview {
    StatisticsView()
}
