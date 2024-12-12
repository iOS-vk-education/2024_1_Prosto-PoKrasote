//
//  WorkoutView.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 29.10.2024.
//

import SwiftUI

struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    @State private var selectedExerciseIndex: Int = -1
    
    @State private var isWeightPickerPresented = false
    @State private var pickerWeight: Double = 0
    @State private var isRepsPickerPresented = false
    @State private var pickerReps: Int = 0
    
    
    enum ConstantSize {
        static let paddingHorizontal: CGFloat = 20
        static let standartExerciseHeight: CGFloat = 48
        static let standartAdditionalHeight: CGFloat = 28
        static let scrollViewHeight: CGFloat = 440
        static let endTrainingHeight: CGFloat = 70
        static let circleSize: CGFloat = 48
    }
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            if viewModel.workoutResultScreen {
                resultView
            } else {
                VStack(spacing: 32) {
                    StandartHeaderText(headerText: "Workout")
                        .padding(.leading, 21)
                    VStack(spacing: 24) {
                        timerView
                        exercisesList
                        plusButton
                        endTrainingButton
                        Spacer()
                    }
                    .padding(.horizontal, ConstantSize.paddingHorizontal)
                }
            }
        }
        .sheet(isPresented: $viewModel.isSheetShowing) {
            AddWorkoutRouterView(content: {
                MuscleGroupsView()
            })
            .environmentObject(viewModel)
        }
    }
    
    // MARK: FIX
    // Fix the UI
    var resultView: some View {
        VStack (alignment: .leading, spacing: 32) {
            StandartHeaderText(headerText: "Good job!")
                .padding(.leading, 21)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 30)
                    .padding(.horizontal, ConstantSize.paddingHorizontal)
                    .foregroundStyle(systemDarkBlueColor)
                    .frame(height: 300)
                VStack {
                    resultRectangleText(textL: "Date:", textR: "\(viewModel.workoutModel.date)")
                    Divider()
                    resultRectangleText(textL: "Intensivity:", textR: "\(viewModel.workoutModel.intensivity)")
                    Divider()
                    resultRectangleText(textL: "Time:", textR: "\(viewModel.workoutModel.time)")
                }
                .padding(.top, 32)
                .padding(.horizontal, ConstantSize.paddingHorizontal * 2)
            }
            Button {
                viewModel.closeWorkoutResultScreen()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(yellowColor, lineWidth: 2)
                    .foregroundStyle(systemDarkBlueColor)
                    .frame(height: ConstantSize.endTrainingHeight)
                    .padding(.horizontal, 54)
                    .overlay {
                        Text("Quit")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                    }
            }
        }
    }
    
    func resultRectangleText(textL: String, textR: String) -> some View {
        return HStack {
            Text(textL)
            Spacer()
            Text(textR)
        }
    }
    
    var timerView : some View {
        Text(viewModel.timeString)
            .font(.system(size: 64))
            .bold()
            .foregroundStyle(yellowColor)
            .kerning(2)
    }
    
    var exercisesList: some View {
        ScrollView {
            ForEach(Array(viewModel.workoutModel.exersises.enumerated()), id: \.element.id) { index, exercise in
                exerciseRectangle(index: index, exercise: exercise)
            }
        }
        .frame(height: ConstantSize.scrollViewHeight)
    }
    
    func exerciseRectangle(index: Int, exercise: ExerciseModel) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedExerciseIndex == index ? yellowColor : gray2, lineWidth: 1)
                .fill(gray6)
                .frame(height: selectedExerciseIndex == index ? ConstantSize.standartExerciseHeight + (ConstantSize.standartAdditionalHeight * CGFloat((2 + exercise.sets.count))) : ConstantSize.standartExerciseHeight)
            if selectedExerciseIndex != index {
                HStack {
                    Text("\(index + 1). \(exercise.exercise.name)")
                        .foregroundStyle(.white)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(yellowColor)
                }
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 0) {
                    CustomRoundedRectangle(cornerRadius: 11)
                        .frame(height: ConstantSize.standartExerciseHeight)
                        .foregroundStyle(gray2)
                        .padding(.horizontal, 1)
                        .padding(.top, 0.5)
                        .overlay {
                            HStack {
                                Text("\(index + 1). \(exercise.exercise.name)")
                                    .foregroundStyle(.white)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(yellowColor)
                            }
                            .padding(.horizontal, 16)
                        }
                    
                    VStack(spacing: 0) {
                        setTopExplanation
                        setList(exercise: exercise, set: exercise.sets)
                        addSetButton(exercise: exercise)
                    }
                }
            }
        }
        .onTapGesture {
            if selectedExerciseIndex != index {
                selectedExerciseIndex = index
            } else {
                selectedExerciseIndex = -1
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedExerciseIndex)
        .padding(.horizontal, 1)
        .padding(.top, 1)
    }
    
    var setTopExplanation: some View {
        HStack {
            Text("Set")
                .font(.system(size: 14))
            Spacer()
            Text("Kg")
                .font(.system(size: 14))
            Spacer()
            Text("Reps")
                .font(.system(size: 14))
            Spacer()
            Image(systemName: "checkmark")
                .font(.system(size: 10))
        }
        .frame(height: 26)
        .foregroundStyle(.white)
        .padding(.horizontal, 32)
    }
    
    func setList(exercise: ExerciseModel,set: [SetModel]) -> some View {
        return ForEach(Array(set.enumerated()), id: \.element.index) { index, set in
            HStack {
                Text("\(index + 1).")
                    .font(.system(size: 14))
                Spacer()
                Text("\(set.weight)")
                    .font(.system(size: 14))
                    .onTapGesture {
                        isWeightPickerPresented.toggle()
                    }
                Spacer()
                Text("\(set.repeats)")
                    .font(.system(size: 14))
                    .onTapGesture {
                        isRepsPickerPresented.toggle()
                    }
                Spacer()
                Image(systemName: "checkmark.square.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(set.isDone ? yellowColor : .white)
                    .onTapGesture {
                        viewModel.doneSet(exercise, set)
                    }
            }
            .frame(height: 26)
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .sheet(isPresented: $isWeightPickerPresented) {
                VStack {
                    Picker("Weight", selection: $pickerWeight) {
                        ForEach(Array(stride(from: 0.0, through: 100.0, by: 0.5)), id: \.self) { value in
                            Text("\(value, specifier: "%.1f")").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    Button("Confirm") {
                        viewModel.saveSet(exercise, set, weight: pickerWeight, reps: nil)
                        isWeightPickerPresented.toggle()
                    }
                }
                .onAppear {
                    pickerWeight = set.weight
                }
            }
            .sheet(isPresented: $isRepsPickerPresented) {
                VStack {
                    Picker("Reps", selection: $pickerReps) {
                        ForEach(0...100, id: \.self) { value in
                            Text("\(value)").tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    Button("Confirm") {
                        viewModel.saveSet(exercise, set, weight: nil, reps: pickerReps)
                        isRepsPickerPresented.toggle()
                    }
                }
                .onAppear {
                    pickerReps = Int(set.repeats)
                }
            }
        }
    }
    
    func addSetButton(exercise: ExerciseModel) -> some View {
        return Button {
            viewModel.addSet(exercise)
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 120, height: 22)
                .foregroundStyle(gray2)
                .overlay {
                    HStack(spacing: 4) {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        Text("Add set")
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                        Spacer()
                    }
                }
        }
        .frame(height: 26)
    }

    
    var plusButton : some View {
        Circle()
            .foregroundStyle(yellowColor)
            .frame(height: ConstantSize.circleSize)
            .overlay {
                Image(systemName: "plus")
                    .foregroundStyle(.black)
                    .font(.system(size: 24))
            }
            .onTapGesture {
                viewModel.plusButtonTapped()
            }
    }
    
    var endTrainingButton : some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(yellowColor)
                .frame(height: ConstantSize.endTrainingHeight)
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(systemDarkBlueColor)
                .frame(height: ConstantSize.endTrainingHeight - 4)
                .padding(2)
            Text("End workout")
                .foregroundStyle(.white)
                .font(.system(size: 24))
                .fontWeight(.bold)
        }
        .opacity(viewModel.timeString == "00:00" ? 0 : 1)
        .animation(.easeInOut(duration: 0.3), value: viewModel.timeString == "00:00")
        .onTapGesture {
            viewModel.endWorkoutButtonTapped()
        }
    }
}

#Preview {
    WorkoutView()
}
