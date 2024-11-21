//
//  AddWorkoutRouter.swift
//  TestTrainStat
//
//  Created by Kovalev Gleb on 18.11.2024.
//

import SwiftUI

class AddWorkoutRouter: ObservableObject {
    enum Route: Hashable {
        case muscleGroup
        case exerciseList(String)
    }
    
    @Published var path: NavigationPath = NavigationPath()
    
    @ViewBuilder func view(for route: Route) -> some View {
        switch route {
        case .muscleGroup:
            MuscleGroupsView()
        case .exerciseList(let muscleGroup):
            ExerciseListView(muscleGroup: muscleGroup)
        }
    }
    
    func navigateTo(_ route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
