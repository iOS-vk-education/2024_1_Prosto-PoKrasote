//
//  ExerciseStatisticsView.swift
//  TrainStat
//
//  Created by Kovalev Gleb on 11.12.2024.
//

import SwiftUI

struct ExerciseStatisticsView: View {
    
    @EnvironmentObject private var router: StatisticsRouter
    @State private var searchText: String = ""
    
    var filteredExercises: [ExerciseList] {
        if searchText.isEmpty {
            return ExerciseList.allCases
        } else {
            return ExerciseList.allCases.filter { exercise in
                exercise.details().name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            StandartHeaderText(headerText: "Exercise statistics")
                .padding(.leading, 21)
            
            // Добавляем SearchBar
            SearchBar(text: $searchText)
                .padding(.horizontal, 32)
            
            ScrollView {
                ForEach(filteredExercises, id: \.self) { exercise in
                    Button {
                        router.navigateTo(.specificExerciseStatisticsView(exercise.details()))
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(height: 70)
                                .foregroundStyle(systemDarkBlueColor)
                                .padding(.horizontal, 32)
                            HStack(spacing: 16) {
                                Text(exercise.details().name)
                                    .font(.system(size: 24))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 25))
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .padding(.bottom, 50)
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

// SearchBar component
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.vertical, 5)
            if !text.isEmpty {
                Button(action: {
                    text = ""  // Сбросить текст при нажатии
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ExerciseStatisticsView()
}
