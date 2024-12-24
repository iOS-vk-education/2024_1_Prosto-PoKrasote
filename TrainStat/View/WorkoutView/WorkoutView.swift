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
    
    @State private var selectedSetIndex: Int?
    @State private var isPickersSheetPresented = false
    @State private var pickerWeight: Double = 0
    @State private var pickerReps: Int = 0
    
    @State private var showOverlayRectangle = false
    @State private var overlayRectCG = CGRect.zero
    
    @State private var listScreenShowing: Bool = true
    @State private var currentExerciseIndex: Int?
    
    @State private var firstScreenOpacity: Bool = true
    @State private var firstRecScreenOpacity: Bool = true
    @State private var secondScreenOpacity: Bool = false
    @State private var secondRecScreenOpacity: Bool = false
    
    enum ConstantSize {
        static let paddingHorizontal: CGFloat = 20
        static let standartExerciseHeight: CGFloat = 48
        static let standartAdditionalHeight: CGFloat = 28
        static let scrollViewHeight: CGFloat = 440 - 48
        static let endTrainingHeight: CGFloat = 70
        static let circleSize: CGFloat = 48
    }
    
    var body: some View {
        if viewModel.workoutResultScreen {
            ZStack {
                Color(.black).ignoresSafeArea()
                resultView
            }
        } else {
            ZStack {
                Color(.black).ignoresSafeArea()
                    .opacity(firstScreenOpacity ? 1 : 0)
                
                overlayRect
                
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
                    .opacity(firstRecScreenOpacity ? 1 : 0)
                
                if currentExerciseIndex != nil {
                    exerciseInfo
                        .opacity(secondRecScreenOpacity ? 1 : 0)
                }
            }
            .sheet(isPresented: $viewModel.isSheetShowing) {
                AddWorkoutRouterView(content: {
                    MuscleGroupsView()
                })
                .environmentObject(viewModel)
            }
        }
    }
}

// MARK: - ListView

extension WorkoutView {
    
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
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        Button {
                            overlayRectCG = geo.frame(in: .global)
                            secondScreenOpacity = true
                            currentExerciseIndex = index
                            withAnimation(.easeInOut(duration: 0.1)) {
                                firstRecScreenOpacity = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    listScreenShowing = false
                                    selectedExerciseIndex = index
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                firstScreenOpacity = false
                                withAnimation {
                                    secondRecScreenOpacity = true
                                }
                                viewModel.startSetTimer()
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(gray6)
                                    .frame(width: 350, height: ConstantSize.standartExerciseHeight)
                                HStack {
                                    Text("\(index + 1). \(exercise.exercise.name)")
                                        .foregroundStyle(.white)
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                .frame(width: 350, height: ConstantSize.standartExerciseHeight)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.top, index == 0 ? 1 : 38)
            }
        }
        .frame(height: ConstantSize.scrollViewHeight)
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
            secondScreenOpacity = false
            viewModel.endWorkoutButtonTapped()
        }
    }
}

// MARK: - Transition Between List And Result Rectangle

extension WorkoutView {
    var overlayRect: some View {
        RoundedRectangle(cornerRadius: 12)
            .foregroundStyle(gray6)
            .frame(width: listScreenShowing ? 350 : UIScreen.main.bounds.width + 900,
                   height: listScreenShowing ? ConstantSize.standartExerciseHeight : UIScreen.main.bounds.height + 900)
            .position(x: overlayRectCG.origin.x + overlayRectCG.width / 2, y: overlayRectCG.origin.y - 3.75 * overlayRectCG.height)
            .opacity(secondScreenOpacity ? 1 : 0)
    }
}

// MARK: - ExerciseView

// 1 - delete !

extension WorkoutView {
    var exerciseInfo: some View {
        VStack {
            crossButton
            setTimer
            ScrollView {
                setList
            }
            .frame(height: ConstantSize.scrollViewHeight)
            addSetButton
            Spacer()
        }
    }
    
    var crossButton: some View {
        HStack {
            Button {
                viewModel.stopSetTimer()
                withAnimation(.easeInOut(duration: 0.1)) {
                    secondRecScreenOpacity = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        listScreenShowing = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    firstScreenOpacity = true
                    withAnimation {
                        firstRecScreenOpacity = true
                    }
                }
                currentExerciseIndex = nil
                selectedExerciseIndex = -1
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundStyle(yellowColor)
                    .font(.system(size: 30))
                    .padding(.leading, 16)
            }
            Spacer()
        }
    }
    
    var setTimer: some View {
        RoundedRectangle(cornerRadius: 100)
            .frame(width: 155, height: 60)
            .foregroundStyle(yellowColor.opacity(0.1))
            .overlay {
                Text(viewModel.setTimeString)
                    .foregroundStyle(yellowColor)
            }
    }
    
    var setList: some View {
        ForEach(Array(viewModel.workoutModel.exersises[currentExerciseIndex!].sets.enumerated()), id: \.element.index) { index, set in
            HStack {
                HStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .frame(width: 56)
                            .foregroundStyle(yellowColor)
                        Circle()
                            .frame(width: 44)
                            .foregroundStyle(gray6)
                        Text("\(index + 1)")
                            .font(.system(size: 20))
                            .foregroundStyle(yellowColor)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 52, height: 42)
                            .foregroundStyle(gray1.opacity(0.1))
                        Text("x\(set.repeats)")
                            .font(.system(size: 16))
                            .foregroundStyle(yellowColor)
                    }
                        .onTapGesture {
                            selectedSetIndex = index
                            isPickersSheetPresented.toggle()
                        }
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .frame(width: 100, height: 42)
                            .foregroundStyle(gray1.opacity(0.1))
                        Text(String(format: "%.1f", set.weight) + " kg")
                            .font(.system(size: 16))
                            .foregroundStyle(yellowColor)
                    }
                        .onTapGesture {
                            selectedSetIndex = index
                            isPickersSheetPresented.toggle()
                        }
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(set.isDone ? yellowColor : yellowColor.opacity(0.1))
                    .onTapGesture {
                        viewModel.startSetTimer()
                        viewModel.doneSet(viewModel.workoutModel.exersises[currentExerciseIndex!], set)
                    }
            }
            .frame(height: 56)
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .sheet(isPresented: $isPickersSheetPresented) {
                ZStack {
                    gray6.ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        
                        HStack(spacing: 16) {
                            VStack {
                                Text("Reps")
                                    .foregroundColor(yellowColor)
                                Picker("Reps", selection: $pickerReps) {
                                    ForEach(0...100, id: \.self) { value in
                                        Text("\(value)").tag(value)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                            
                            Text("x")
                                .foregroundStyle(yellowColor)
                                .font(.system(size: 24))
                            
                            VStack {
                                Text("Weight")
                                    .foregroundColor(yellowColor)
                                Picker("Weight", selection: $pickerWeight) {
                                    ForEach(Array(stride(from: 0.0, through: 100.0, by: 0.5)), id: \.self) { value in
                                        Text("\(value, specifier: "%.1f")").tag(value)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                            
                            Text("kg")
                                .foregroundStyle(yellowColor)
                                .font(.system(size: 20))
                        }
                        
                        Button("Confirm") {
                            if let selectedSetIndex {
                                viewModel.saveSet(
                                    viewModel.workoutModel.exersises[currentExerciseIndex!],
                                    selectedSetIndex,
                                    weight: pickerWeight,
                                    reps: pickerReps
                                )
                            }
                            isPickersSheetPresented.toggle()
                        }
                        .font(.title2)
                        .foregroundStyle(yellowColor)
                    }
                }
                .tint(yellowColor)
                .presentationDetents([.medium, .large])
                .onAppear {
                    if let selectedSetIndex {
                        let selectedSet = viewModel
                            .workoutModel
                            .exersises[currentExerciseIndex!]
                            .sets[selectedSetIndex]
                        
                        pickerReps = Int(selectedSet.repeats)
                        pickerWeight = selectedSet.weight
                    }
                }
            }
        }
    }
    
    var addSetButton: some View {
        Button {
            viewModel.addSet(viewModel.workoutModel.exersises[currentExerciseIndex!])
        } label: {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 46)
                .foregroundStyle(yellowColor.opacity(0.1))
                .padding(.horizontal, 16)
                .overlay {
                    HStack(spacing: 10) {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundStyle(yellowColor)
                            .font(.system(size: 16))
                        Text("Add set")
                            .foregroundStyle(yellowColor)
                            .font(.system(size: 16))
                        Spacer()
                    }
                }
        }
        .frame(height: 46)
    }
}

// MARK: - ResultView

extension WorkoutView {
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
}

// MARK: - Preview

#Preview {
    WorkoutView()
}
